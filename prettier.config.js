import config from '@hyperupcall/scripts-nodejs/config-prettier.js'

export default {
	...config,
	overrides: [
		{
			files: ['**/Code/User/*.json', '**/zed/*.json'],
			options: { parser: 'jsonc' },
		},
	],
}
