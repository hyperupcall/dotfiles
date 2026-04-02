node --input-type=module <<'EOF'
import { readFileSync } from 'fs'
import { glob } from 'fs/promises'

const EXPECTED_ORDER = [
	'install.any',
	'install.debian',
	'install.ubuntu',
	'install.fedora',
	'install.opensuse',
	'install.arch',
	'installed',
	'configure',
	'caveats',
]

let err = 0

for await (const file of glob('**/*.sh', { exclude: (p) => p === '.data' || p === 'vendor' })) {
	const lines = readFileSync(file, 'utf8').split('\n')

	if (!lines.some(l => l.includes('_setup '))) continue

	const order = []
	for (const line of lines) {
		for (const name of EXPECTED_ORDER) {
			if (line.startsWith(name + '(')) order.push(name)
		}
	}

	for (let i = 0; i < order.length; i++) {
		for (let j = i + 1; j < order.length; j++) {
			const pi = EXPECTED_ORDER.indexOf(order[i])
			const pj = EXPECTED_ORDER.indexOf(order[j])
			if (pi > pj) {
				console.log(`Bad ordering in ${file}: ${order[j]}() must be before ${order[i]}()`)
				err = 1
			}
		}
	}
}

process.exit(err)
EOF
