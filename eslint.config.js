import config from '@hyperupcall/scripts-nodejs/config-eslint.js'
import tsParser from '@typescript-eslint/parser'
import pluginUnicorn from 'eslint-plugin-unicorn'
import globals from 'globals'
export default [
	{
		ignores: [
			'.data/**',
			'vendor/**',
			'.venv/**',
			'.lsp/.cache/**',
			'.clj-kondo/**',
			'docs/_site/**',
		],
	},
	...config.map((entry) => ({
		...entry,
		...(entry.files && {
			files: entry.files.map((pattern) =>
				pattern === '**/*.js' ? '**/*.{js,mjs}' : pattern,
			),
		}),
	})),
	{
		files: ['**/*.ts'],
		languageOptions: {
			globals: { ...globals.browser, Deno: 'readonly' },
			parser: tsParser,
		},
	},
	{
		files: ['**/Code/User/custom.js'],
		rules: { 'unicorn/no-empty-file': 'off' },
	},
	{
		files: ['**/.hyper.js'],
		languageOptions: { sourceType: 'commonjs' },
		rules: { 'unicorn/prefer-module': 'off' },
	},
	{
		plugins: {
			unicorn: pluginUnicorn,
		},
	},
	{
		files: ['**/firefox/user.js'],
		languageOptions: {
			globals: {
				user_pref: 'readonly',
			},
		},
	},
	{
		files: ['**/*.user.js'],
		languageOptions: {
			globals: {
				...globals.browser,
				GM_config: 'readonly',
				GM_registerMenuCommand: 'readonly',
				GM_xmlhttpRequest: 'readonly',
			},
		},
		rules: {
			'unicorn/prefer-module': 'off',
		},
	},
	{
		files: ['**/Code/User/*.json', '**/zed/*.json'],
		language: 'json/jsonc',
	},
	{
		files: ['**/*.{js,mjs}'],
		rules: {
			'unicorn/catch-error-name': [
				'error',
				{
					name: 'err',
				},
			],
			'unicorn/name-replacements': 'off',
			'unicorn/no-array-callback-reference': 'off',
			'unicorn/prefer-query-selector': [
				'error',
				{
					allowWithVariables: true,
				},
			],
			'unicorn/prevent-abbreviations': 'off',
		},
	},
	{
		files: ['scripts/*.mjs'],
		rules: {
			'n/hashbang': 'off',
			'n/no-process-exit': 'off',
			'unicorn/no-process-exit': 'off',
		},
	},
	{
		rules: {
			'unicorn/filename-case': 'off',
		},
	},
]
