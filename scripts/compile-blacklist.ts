#!/usr/bin/env -S deno run --allow-net --allow-write

const blocklists: { link: string, type: 'ublockorigin' | 'ublacklist' }[] = [
	// https://github.com/popcar2/BadWebsiteBlocklist
	{ link: 'https://raw.githubusercontent.com/popcar2/BadWebsiteBlocklist/refs/heads/main/uBlacklist.txt', type: 'ublockorigin' },

	// https://github.com/quenhus/uBlock-Origin-dev-filter
	{ link: 'https://raw.githubusercontent.com/quenhus/uBlock-Origin-dev-filter/main/dist/other_format/uBlacklist/all.txt', type: 'ublockorigin' },

	// https://github.com/elliotwutingfeng/SpamdexingSites
	{ link: 'https://raw.githubusercontent.com/elliotwutingfeng/SpamdexingSites/refs/heads/main/blocklist_UBL.txt', type: 'ublacklist' },
	{ link: 'https://raw.githubusercontent.com/elliotwutingfeng/SpamdexingSites/refs/heads/main/blocklist_UBO.txt', type: 'ublacklist' },

	// https://github.com/quenhus/uBlock-Origin-dev-filter
	{ link: 'https://raw.githubusercontent.com/quenhus/uBlock-Origin-dev-filter/main/dist/other_format/uBlacklist/global.txt', type: 'ublacklist' },

	// https://github.com/NotaInutilis/Super-SEO-Spam-Suppressor
	{ link: 'https://raw.githubusercontent.com/NotaInutilis/Super-SEO-Spam-Suppressor/main/ublacklist.txt', type: 'ublacklist' },
	{ link: 'https://raw.githubusercontent.com/NotaInutilis/Super-SEO-Spam-Suppressor/main/adblock.txt', type: 'ublockorigin' },

	// https://codeberg.org/legendary_creeper/safebrowsing-for-minecrafters
	{ link: 'https://codeberg.org/legendary_creeper/safebrowsing-for-minecrafters/raw/branch/main/safebrowsing-for-minecrafters.txt', type: 'ublockorigin' },
	{ link: 'https://codeberg.org/legendary_creeper/safebrowsing-for-minecrafters/raw/branch/main/safebrowsing-for-minecrafters-ublacklist.txt', type: 'ublacklist' },

	// https://github.com/franga2000/aliexpress-fake-sites
	{ link: 'https://raw.githubusercontent.com/franga2000/aliexpress-fake-sites/main/domains_uBlacklist.txt', type: 'ublacklist' },

	// https://github.com/arosh/ublacklist-github-translation
	{ link: 'https://raw.githubusercontent.com/arosh/ublacklist-github-translation/master/uBlacklist.txt', type: 'ublacklist' },

	// https://github.com/arosh/ublacklist-stackoverflow-translation
	{ link: 'https://raw.githubusercontent.com/arosh/ublacklist-stackoverflow-translation/master/uBlacklist.txt', type: 'ublacklist' },

	// https://github.com/rjaus/ublacklist-pinterest
	{ link: 'https://raw.githubusercontent.com/rjaus/ublacklist-pinterest/main/ublacklist-pinterest-ext-ovk.txt', type: 'ublacklist' }
]

await Promise.all(['ublockorigin', 'ublacklist'].map(async (curType) => {
	const data = (await Promise.all(blocklists.filter(({ link, type }) => {
		return type === curType
	}).map(async ({ link, type }) => {
			const comment = type === 'ublacklist' ? '#' : '!'
			const content = await (await fetch(link)).text()

			let text = ''
			text += `${comment} ${'='.repeat(80)}\n${comment} START: ${link}\n${comment} ${'='.repeat(80)}\n`
			text += content.replace(/^---.*?\n---\n/s, '')
			text += `${comment} ${'='.repeat(80)}\n${comment} END: ${link}\n${comment} ${'='.repeat(80)}\n\n\n`
			return text
	}))).join('')
	await Deno.writeTextFile(`./config/${curType}-compiled.txt`, data)
}))
