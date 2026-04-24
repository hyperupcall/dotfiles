#!/usr/bin/env -S deno run --allow-env --allow-net --allow-read --allow-write
import * as path from "jsr:@std/path";

// deno-fmt-ignore
const blocklists: { link: string, type: 'ublockorigin' | 'ublacklist' }[] = [
	// https://github.com/popcar2/BadWebsiteBlocklist
	{ type: 'ublockorigin', link: 'https://raw.githubusercontent.com/popcar2/BadWebsiteBlocklist/refs/heads/main/uBlacklist.txt' },

	// https://github.com/quenhus/uBlock-Origin-dev-filter
	{ type: 'ublockorigin', link: 'https://raw.githubusercontent.com/quenhus/uBlock-Origin-dev-filter/main/dist/other_format/uBlacklist/all.txt' },

	// https://github.com/elliotwutingfeng/SpamdexingSites
	{ type: 'ublacklist', link: 'https://raw.githubusercontent.com/elliotwutingfeng/SpamdexingSites/refs/heads/main/blocklist_UBL.txt' },
	{ type: 'ublacklist', link: 'https://raw.githubusercontent.com/elliotwutingfeng/SpamdexingSites/refs/heads/main/blocklist_UBO.txt' },

	// https://github.com/quenhus/uBlock-Origin-dev-filter
	{ type: 'ublacklist', link: 'https://raw.githubusercontent.com/quenhus/uBlock-Origin-dev-filter/main/dist/other_format/uBlacklist/global.txt' },

	// https://github.com/NotaInutilis/Super-SEO-Spam-Suppressor
	{ type: 'ublacklist', link: 'https://raw.githubusercontent.com/NotaInutilis/Super-SEO-Spam-Suppressor/main/ublacklist.txt' },
	{ type: 'ublockorigin', link: 'https://raw.githubusercontent.com/NotaInutilis/Super-SEO-Spam-Suppressor/main/adblock.txt' },

	// https://codeberg.org/legendary_creeper/safebrowsing-for-minecrafters
	{ type: 'ublockorigin', link: 'https://codeberg.org/legendary_creeper/mc-safebrowsing/raw/branch/main/mc-sb.txt' },
	{ type: 'ublacklist', link: 'https://codeberg.org/legendary_creeper/mc-safebrowsing/raw/branch/main/mc-sb-ublacklist.txt' },

	// https://github.com/franga2000/aliexpress-fake-sites
	{ type: 'ublacklist', link: 'https://raw.githubusercontent.com/franga2000/aliexpress-fake-sites/main/domains_uBlacklist.txt' },

	// https://github.com/arosh/ublacklist-github-translation
	{ type: 'ublacklist', link: 'https://raw.githubusercontent.com/arosh/ublacklist-github-translation/master/uBlacklist.txt' },

	// https://github.com/arosh/ublacklist-stackoverflow-translation
	{ type: 'ublacklist', link: 'https://raw.githubusercontent.com/arosh/ublacklist-stackoverflow-translation/master/uBlacklist.txt' },

	// https://github.com/rjaus/ublacklist-pinterest
	{ type: 'ublacklist', link: 'https://raw.githubusercontent.com/rjaus/ublacklist-pinterest/main/ublacklist-pinterest-ext-ovk.txt' }
]

const ignoreFile = path.join(
	import.meta.dirname,
	"~/.devresources/ublacklist-ignored.txt",
);
const ignoreSet = new Set(
	Deno.readTextFileSync(ignoreFile).split("\n").map((item) =>
		`*://*.${item}/*`
	),
);

await Promise.all(["ublockorigin", "ublacklist"].map(async (appName) => {
	const data = (await Promise.all(
		blocklists.filter(({ type }) => type === appName).map(
			async ({ link, type }) => {
				const comment = type === "ublacklist" ? "#" : "!";
				const res = await fetch(link);
				if (!res.ok) {
					throw new Error(`Failed to fetch content from: ${link}`);
				}
				let content = await res.text();
				content = content.replace(/^---.*?\n---\n/s, "");

				const arr = content.split("\n");
				for (let i = 0; i < arr.length; i += 1) {
					if (
						ignoreSet.has(arr[i]) &&
						!arr[i].startsWith("#")
					) {
						arr[i] = `${comment}${arr[i]} ${comment} Ignored.`;
					}
				}
				content = arr.join("\n");

				let text = "";
				text += `${comment} ${
					"=".repeat(80)
				}\n${comment} START: ${link}\n${comment} ${"=".repeat(80)}\n`;
				text += content;
				text += `${comment} ${
					"=".repeat(80)
				}\n${comment} END: ${link}\n${comment} ${
					"=".repeat(80)
				}\n\n\n\n\n\n\n`;
				return text;
			},
		),
	)).join("");
	await Deno.writeTextFile(`~/.devresources/${appName}-compiled.txt`, data);
}));
