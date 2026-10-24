module.exports = {
	config: {
		backgroundColor: '#000',

		bell: 'SOUND',
		borderColor: '#333',
		// the full list. if you're going to provide the full color palette,
		// including the 6 x 6 color cubes and the grayscale map, just provide
		// an array here instead of a color map object
		colors: {
			black: '#000000',
			blue: '#0A2FC4',
			cyan: '#20C5C6',
			green: '#1DC121',
			lightBlack: '#686868',
			lightBlue: '#6A76FB',
			lightCyan: '#68FDFE',
			lightGreen: '#67F86F',
			lightMagenta: '#FD7CFC',
			lightRed: '#FD6F6B',
			lightWhite: '#FFFFFF',
			lightYellow: '#FFFA72',
			magenta: '#C839C5',
			red: '#C51E14',
			white: '#C7C7C7',
			yellow: '#C7C329',
		},
		copyOnSelect: false,
		css: '',
		cursorAccentColor: '#000',

		cursorBlink: false,
		cursorColor: 'rgba(248,28,229,0.8)',
		// `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
		cursorShape: 'BLOCK',
		defaultSSHApp: false,

		env: {},
		fontFamily: 'Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',
		fontSize: 12,
		fontWeight: 'normal',
		fontWeightBold: 'bold',
		foregroundColor: '#fff',

		letterSpacing: 0,

		lineHeight: 1,

		macOptionSelectionMode: 'vertical',

		padding: '12px 14px',

		quickEdit: false,
		selectionColor: 'rgba(248,28,229,0.3)',
		shell: '',
		shellArgs: [],

		// if you're using a Linux setup which show native menus, set to false
		// default: `true` on Linux, `true` on Windows, ignored on macOS
		showHamburgerMenu: '',
		// set to `false` (without backticks and without quotes) if you want to hide the minimize, maximize and close buttons
		// additionally, set to `'left'` if you want them on the left, like in Ubuntu
		// default: `true` (without backticks and without quotes) on Windows and Linux, ignored on macOS
		showWindowControls: '',
		termCSS: '',
		updateChannel: 'stable',

		// bellSoundURL: 'https://example.com/bell.mp3',
		webGLRenderer: true,
	},

	keymaps: {
		// 'window:devtools': 'cmd+alt+o',
	},

	// in development, you can create a directory under
	// `~/.hyper_plugins/local/` and include it here
	// to load it and avoid it being `npm install`ed
	localPlugins: [],

	// a list of plugins to fetch and install from npm
	// format: [@org/]project[#version]
	// examples:
	//   `hyperpower`
	//   `@company/project`
	//   `project#1.0.1`
	plugins: [
		'hypercwd',
		'hyper-search',
		'hyper-pane',
		'hyperline',
		'hyper-tabs-enhanced',
		'hyper-statusline',
		'hyperpower',
		'hyper-solarized-dark',
		// 'hyperterm-base-16-ocean',
		// 'hyperterm-monokai',
		// 'hyper-material-theme',
		// 'hyper-solarized-light',
		// 'hyper-dracula',
	],
}
