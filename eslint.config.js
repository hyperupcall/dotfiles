import globals from 'globals'
import config from '@hyperupcall/scripts-nodejs/config-eslint.js'
import pluginUnicorn from 'eslint-plugin-unicorn'
export default [
	{
		ignores: ['.data/**', 'vendor/**'],
	},
	...config,
	{
		plugins: {
			unicorn: pluginUnicorn,
		},
	},
	{
		files: ["**/firefox/user.js"],
		languageOptions: {
			globals: {
				user_pref: 'readonly'
			}
		}
	},
	{
		files: ["**/*.user.js"],
		languageOptions: {
			globals: {
				...globals.browser,
				GM_config: "readonly",
				GM_registerMenuCommand: 'readonly',
				GM_xmlhttpRequest: 'readonly'
			}
		},
		rules: {
			'unicorn/prefer-module': 'off'
		}
	},
	{
		files: ['**/Code/User/*.json', ".config/zed/*.json"],
		language: 'json/jsonc'
	},
	{
		files: ["**/*.js"],
		rules: {
			'unicorn/name-replacements': 'off',
			'unicorn/prevent-abbreviations': 'off',
			'unicorn/prefer-query-selector': ['error', {
				allowWithVariables: true
			}],
			'unicorn/catch-error-name': [
				'error',
				{
					name: 'err'
				},
			],
			'unicorn/no-array-callback-reference': 'off'
		}
	},
	{
		rules: {
			'unicorn/filename-case': 'off',
		}
	}
]
