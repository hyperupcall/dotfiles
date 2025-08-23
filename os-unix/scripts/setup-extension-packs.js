#!/usr/bin/env deno
import type { PackageJson } from 'npm:typefest'

const text = await fetch('https://raw.githubusercontent.com/hyperupcall-self/vscode-hyperupcall-packs/refs/heads/main/extension-list.json')
const json = text.json()

for (const package of json) {

}
