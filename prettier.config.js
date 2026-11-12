import config from '@hyperupcall/prettier-config'

export default {
	...config,
	overrides: [
		{
			files: ['**/Code/User/*.json', '**/zed/*.json'],
			options: { parser: 'jsonc' },
		},
	],
}
