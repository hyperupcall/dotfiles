#!/usr/bin/env zx
// Transfer data between machines via an encrypted removable drive.
//
// JavaScript (zx) rewrite of `transfer-data.sh`. It saves selected files and
// directories to a removable drive (encrypting the sensitive ones with a
// password) and restores them on another machine.

import { randomInt } from 'node:crypto'
import { $, echo, fs, os, path, question } from 'zx'

// Run commands with the terminal attached, so interactive commands (notably
// `sudo`) can prompt and command warnings stay visible. Commands whose output
// must be captured opt into `stdio: 'pipe'` explicitly.
$.stdio = 'inherit'

const home = os.homedir()
const dotfilesDir = path.join(home, '.dotfiles')
const setupSh = path.join(dotfilesDir, 'config', 'setup.sh')
const setupPrivateSh = path.join(dotfilesDir, 'config', 'setup-private.sh')
const bootstrapSh = path.join(dotfilesDir, 'bootstrap-linux.sh')

// ---------------------------------------------------------------------------
// Logging (mirrors the `core.print_*` helpers from bash-core)
// ---------------------------------------------------------------------------

function die(message) {
	printFatal(message)
	process.exit(1)
}

function printFatal(message) {
	const label = shouldPrintColor(process.stderr)
		? '\u{1B}[1;35mFatal:\u{1B}[0m'
		: 'Fatal:'
	process.stderr.write(`${label} ${message}\n`)
}

function printInfo(message) {
	const label = shouldPrintColor(process.stdout) ? '\u{1B}[1;32mInfo:\u{1B}[0m' : 'Info:'
	process.stdout.write(`${label} ${message}\n`)
}

function printWarn(message) {
	const label = shouldPrintColor(process.stderr) ? '\u{1B}[1;33mWarn:\u{1B}[0m' : 'Warn:'
	process.stderr.write(`${label} ${message}\n`)
}

function shouldPrintColor(fd) {
	if ('NO_COLOR' in process.env) return false

	const forceColor = process.env.FORCE_COLOR
	if (['1', '2', '3'].includes(forceColor)) return true
	if (forceColor === '0') return false

	if (process.env.TERM === 'dumb') return false

	return Boolean(fd?.isTTY)
}

// ---------------------------------------------------------------------------
// Prompts
// ---------------------------------------------------------------------------

// Characters read ahead of the current prompt, so that a chunk of piped input
// is not discarded (bash's `read -N1` buffers the remainder the same way).
const pendingChars = []

async function decryptSetupPrivate(sourceFile, destinationFile, password, homedir) {
	await fs.ensureDir(path.dirname(destinationFile))
	await $`gpg ${gpgArguments(homedir)} --decrypt ${sourceFile} 3<<<${password} | tar -xO > ${destinationFile}`
}

async function decryptToDir(sourceFile, destDir, password, homedir) {
	const parent = path.dirname(destDir)

	await fs.ensureDir(parent)
	await $`cat ${sourceFile} | gpg ${gpgArguments(homedir)} --decrypt 3<<<${password} | tar -C ${parent} -x`
}

async function encryptDir(srcDir, destinationFile, password, homedir) {
	const parent = path.dirname(srcDir)
	const base = path.basename(srcDir)

	await fs.ensureDir(path.dirname(destinationFile))
	await $`tar -C ${parent} -c ${`./${base}`} | gpg ${gpgArguments(homedir)} --symmetric 3<<<${password} > ${destinationFile}`
}

// ---------------------------------------------------------------------------
// Environment
// ---------------------------------------------------------------------------

function generatePassword(length) {
	let password = ''
	for (let index = 0; index < length; index++) {
		// Printable ASCII (`[:graph:]`), i.e. 0x21..0x7E.
		password += String.fromCodePoint(randomInt(0x21, 0x7f))
	}
	return password
}

// ---------------------------------------------------------------------------
// Mount points
// ---------------------------------------------------------------------------

function gpgArguments(homedir) {
	return [
		'--homedir',
		homedir,
		'--no-keyring',
		'--batch',
		'--yes',
		'--pinentry-mode',
		'loopback',
		'--passphrase-fd',
		'3',
		'--cipher-algo',
		'AES256',
		'--no-symkey-cache',
		'--armor',
	]
}

// ---------------------------------------------------------------------------
// Encryption
// ---------------------------------------------------------------------------

async function listMountOptions() {
	const { stdout } = await $({
		quiet: true,
		stdio: 'pipe',
	})`lsblk --list --json --output ID,FSSIZE,FSTYPE,MODEL,PATH,NAME,LABEL,MOUNTPOINT`
	const data = JSON.parse(stdout)

	const devices = (data.blockdevices ?? []).filter(
		(device) =>
			device.mountpoint != undefined && /^\/mnt|\/media|\/run/.test(device.mountpoint),
	)

	const options = []
	for (const [index, device] of devices.entries()) {
		const id = (device.id ?? '').slice(0, 50)
		echo(
			`#${index}\n` +
				`  ID: ${id}...\n` +
				`  MOUNTPOINT: ${device.mountpoint} (${device.path})\n` +
				`  SIZE: ${device.fssize} (${device.fstype})`,
		)
		options.push(device.mountpoint)
	}

	return options
}

// Source `setup.sh` in a fresh shell (so its shell options do not leak) and
// read the XDG base directory variables it exports.
async function loadXdgDirectories() {
	const script = [
		`source ${setupSh} >/dev/null 2>&1`,
		'echo "${XDG_CONFIG_HOME-}"',
		'echo "${XDG_DATA_HOME-}"',
		'echo "${XDG_STATE_HOME-}"',
	].join('; ')

	const { stdout } = await $({
		nothrow: true,
		quiet: true,
		stdio: 'pipe',
	})`bash -c ${script}`
	const [configHome, dataHome, stateHome] = stdout.split('\n')

	if (configHome && dataHome && stateHome) {
		return { configHome, dataHome, stateHome }
	}

	return {
		configHome: process.env.XDG_CONFIG_HOME ?? '',
		dataHome: process.env.XDG_DATA_HOME ?? '',
		stateHome: process.env.XDG_STATE_HOME ?? '',
	}
}

async function main() {
	const { configHome, dataHome, stateHome } = await loadXdgDirectories()

	let mode
	while (true) {
		mode = await question('Which mode? (save|restore): ')
		if (mode === 'save' || mode === 'restore') break
	}

	const options = await listMountOptions()
	options.push('__manual__')
	echo(`#${options.length - 1}\n  MOUNTPOINT: (specify manually)`)

	let answer
	while (true) {
		answer = await question('Choose location for temporary files: ')
		if (/^\d+$/.test(answer) && Number(answer) < options.length) break
	}

	let devicePath = options[Number(answer)]
	if (devicePath === '__manual__') {
		devicePath = await question('Enter directory path: ')
	}

	const dirpath = `${devicePath.replace(/\/$/, '')}/_data`

	if (!(await fs.pathExists(setupPrivateSh))) {
		const tempGnupgDir = await fs.mkdtemp(path.join(os.tmpdir(), 'gnupg-'))
		const pwFile = path.join(dirpath, 'pw.txt')
		let passwordText = ''
		try {
			passwordText = await fs.readFile(pwFile, 'utf8')
		} catch {
			// An absent password file falls back to an empty passphrase.
		}
		const password = passwordText.trimEnd()
		await decryptSetupPrivate(
			path.join(dirpath, 'setup_private_sh.tar.gz.asc'),
			setupPrivateSh,
			password,
			tempGnupgDir,
		)
	}

	const pathsEncrypt = {
		basalt_token: path.join(configHome, 'basalt/token'),
		borgkeys: path.join(configHome, 'borg/keys'),
		dotfiles_git_exclude: path.join(dotfilesDir, '.git/info/exclude'),
		gnupg: path.join(home, '.gnupg'),
		history: path.join(stateHome, 'history'),
		// scripts_hidden: privateScriptsHidden,
		setup_private_exec_sh: path.join(dotfilesDir, 'config/setup-private-exec.sh'),
		setup_private_py: path.join(dotfilesDir, 'config/setup-private.py'),
		setup_private_sh: setupPrivateSh,
		ssh: path.join(home, '.ssh'),
		syncthing: path.join(stateHome, 'syncthing'),
		woof_token: path.join(dataHome, 'woof/token'),
	}
	const paths = {
		ankiaddons: path.join(dataHome, 'Anki2/addons21'),
		ankiuserdata: path.join(dataHome, 'Anki2/Default User'),
		applicationsdir: path.join(home, 'Other/Application Data'),
		dbeaver: path.join(dataHome, 'DBeaverData/workspace6/General/Scripts'),
		devresources: path.join(home, '.devhidden'),
		fonts: path.join(dataHome, 'fonts'),
		libreoffice: path.join(configHome, 'libreoffice/4/user'),
	}

	if (mode === 'save') {
		await save(dirpath, pathsEncrypt, paths)
	} else if (mode === 'restore') {
		await restore(dirpath, pathsEncrypt, paths)
	} else {
		die(`Invalid mode: ${mode}`)
	}

	const deviceRoot = path.dirname(dirpath)
	if (await promptYesNo(`Done! Would you like to unmount ${deviceRoot}? `)) {
		process.chdir(home)
		await $({ nothrow: true })`sudo umount ${deviceRoot}`
	}

	printInfo('Exiting.')
}

// Reads a single character without waiting for Enter (like bash's `read -N1`).
async function promptOneChar(promptText) {
	process.stdout.write(promptText)

	const isTTY = Boolean(process.stdin.isTTY)
	if (isTTY) process.stdin.setRawMode(true)

	try {
		const char = await readCharFromStdin()

		if (char === '\u{3}') {
			// Raw mode swallows Ctrl+C, so emulate the signal.
			process.stdout.write('\n')
			process.exit(130)
		}

		// Raw mode disables echo, so echo the character manually.
		if (isTTY) process.stdout.write(char)
		return char
	} finally {
		if (isTTY) process.stdin.setRawMode(false)
		process.stdout.write('\n')
	}
}

async function promptYesNo(promptText) {
	const char = await promptOneChar(promptText)
	return char.toLowerCase() === 'y'
}

// ---------------------------------------------------------------------------
// Save / restore
// ---------------------------------------------------------------------------

function readCharFromStdin() {
	if (pendingChars.length > 0) {
		return Promise.resolve(pendingChars.shift())
	}

	return new Promise((resolve) => {
		const onData = (data) => {
			process.stdin.off('data', onData)
			process.stdin.pause()

			const text = data.toString('utf8')
			for (let index = 1; index < text.length; index++) pendingChars.push(text[index])
			resolve(text[0] ?? '')
		}

		process.stdin.resume()
		process.stdin.on('data', onData)
	})
}

async function removeBrokenSymlinks(directory) {
	const entries = await fs.readdir(directory)
	for (const entry of entries) {
		// Bash globs do not match dotfiles.
		if (entry.startsWith('.')) continue

		const full = path.join(directory, entry)
		const stat = await fs.lstat(full)
		if (stat.isSymbolicLink() && !(await fs.pathExists(full))) {
			await fs.unlink(full)
		}
	}
}

async function restore(dirpath, pathsEncrypt, paths) {
	const pwFile = path.join(dirpath, 'pw.txt')
	let password
	if (await fs.pathExists(pwFile)) {
		const passwordText = await fs.readFile(pwFile, 'utf8')
		password = passwordText.trimEnd()
		printInfo(`Using password from ${pwFile}`)
	} else {
		password = await question('Password? ')
	}

	const temporaryGnupg = await fs.mkdtemp(path.join(os.tmpdir(), 'gnupg-'))

	for (const [name, directory] of Object.entries(pathsEncrypt)) {
		// Mirrors the original check, which is currently a no-op.
		if (directory === 'scripts_hidden') continue

		const encryptedFile = path.join(dirpath, `${name}.tar.gz.asc`)

		if (await fs.pathExists(directory)) {
			printWarn(`File or directory ${directory} already exists`)
			if (await promptYesNo('Remove? [y/n] ')) {
				await $`rm -rf ${directory}`
			} else {
				printWarn(`Skipping directory ${directory}`)
				continue
			}
		} else if (!(await promptYesNo(`Copy to ${directory}? [y/n] `))) {
			printWarn(`Skipping directory ${directory}`)
			continue
		}

		printInfo(`Decrypting ${encryptedFile} to ${directory}`)
		await decryptToDir(encryptedFile, directory, password, temporaryGnupg)

		// Ensure that no broken symlinks are copied over.
		let stat
		try {
			stat = await fs.stat(directory)
		} catch {
			// Missing paths have no symlinks to clean up.
		}
		if (stat?.isDirectory()) {
			await removeBrokenSymlinks(directory)
		}
	}

	for (const [name, directory] of Object.entries(paths)) {
		const source = path.join(dirpath, `${name}.tar.gz`)

		if (await fs.pathExists(directory)) {
			printWarn(`File or directory ${directory} already exists`)
			if (await promptYesNo('Remove? [y/n] ')) {
				await $`rm -rf ${directory}`
			} else {
				printWarn(`Skipping directory ${directory}`)
				continue
			}
		} else if (!(await promptYesNo(`Copy to ${directory}? [y/n] `))) {
			printWarn(`Skipping directory ${directory}`)
			continue
		}

		printInfo(`Extracting ${source} to ${directory}`)
		await fs.ensureDir(directory)
		// The directory may contain symlinks, so copy as a tarball so it is always
		// preserved, no matter the file system.
		await $`tar -C ${directory} -xf ${source}`
	}
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function save(dirpath, pathsEncrypt, paths) {
	await $`sudo rm -rf ${dirpath}`
	await $`sudo mkdir -p ${dirpath}`
	const user = process.env.USER ?? ''
	await $`sudo chown ${`${user}:${user}`} ${dirpath}`

	await fs.copy(import.meta.filename, path.join(dirpath, 'transfer-data.mjs'))
	await fs.copy(bootstrapSh, path.join(dirpath, 'bootstrap.sh'))
	await fs.chmod(path.join(dirpath, 'transfer-data.mjs'), 0o755)
	await fs.chmod(path.join(dirpath, 'bootstrap.sh'), 0o755)

	const password = generatePassword(14)
	const temporaryGnupg = await fs.mkdtemp(path.join(os.tmpdir(), 'gnupg-'))
	printInfo(`Password: ${password}`)

	if (await promptYesNo('Save password to _data/pw.txt? [y/n] ')) {
		await fs.ensureDir(dirpath)
		await fs.writeFile(path.join(dirpath, 'pw.txt'), `${password}\n`)
		printInfo(`Password written to ${dirpath}/pw.txt`)
	}

	for (const [name, directory] of Object.entries(pathsEncrypt)) {
		const encryptedFile = path.join(dirpath, `${name}.tar.gz.asc`)

		if (!directory || !(await fs.pathExists(directory))) {
			printWarn(`Skipping ${name}: '${directory}' does not exist`)
			continue
		}

		printInfo(`Encrypting ${directory} to ${encryptedFile}`)
		await encryptDir(directory, encryptedFile, password, temporaryGnupg)
	}

	for (const [name, directory] of Object.entries(paths)) {
		const source = path.join(dirpath, `${name}.tar.gz`)

		if (!directory || !(await fs.pathExists(directory))) {
			printWarn(`Skipping ${name}: '${directory}' does not exist`)
			continue
		}

		printInfo(`Copying ${directory} to ${source}`)
		await fs.ensureDir(path.dirname(source))
		// The directory may contain symlinks, so copy as a tarball so it is always
		// preserved, no matter the file system.
		await $`tar -C ${directory} -cf ${source} .`
	}
}

process.on('SIGINT', () => {
	process.stdout.write('\n')
	process.exit(130)
})

try {
	await main()
} catch (err) {
	if (err && typeof err === 'object' && 'exitCode' in err) {
		die(`Command failed with exit code ${err.exitCode}`)
	}
	die(err instanceof Error ? err.message : String(err))
}
