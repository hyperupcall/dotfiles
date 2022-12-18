local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use {
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	}

	use {
		'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' }
	}
	use('nvim-treesitter/playground')
	use('theprimeagen/harpoon')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')

	use {
		'VonHeikemen/lsp-zero.nvim',
		requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
		}
	 }
	-- -- jump
	-- -- use 'phaazon/hop.nvim' -- lua
	-- -- use 'ggandor/leap.nvim' -- fennel
	-- -- use 'justinmk/vim-sneak'
	-- -- use 'easymotion/vim-easymotion'

	-- -- status lines
	-- use {
	-- 	'nvim-lualine/lualine.nvim',
	-- 	requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	-- }

	-- -- file explorers
	-- use 'preservim/nerdtree'
	-- -- use {
	-- -- 	'kyazdani42/nvim-tree.lua',
	-- -- 	requires = {
	-- -- 		'kyazdani42/nvim-web-devicons',
	-- -- 	},
	-- -- 	tag = 'nightly' -- optional, updated every week. (see issue #1193)
	-- -- }

	-- -- formatting
	-- use 'gpanders/editorconfig.nvim'

	-- use {
	-- 	'numToStr/Comment.nvim',
	-- 	config = function()
	-- 		require('Comment').setup()
	-- 	end
	-- }

	-- use {
	-- 	"folke/todo-comments.nvim",
	-- 	requires = "nvim-lua/plenary.nvim",
	-- 	config = function()
	-- 	require("todo-comments").setup {
	-- 	}
	-- 	end
	-- }

	-- -- startup
	-- use 'startup-nvim/startup.nvim'
	-- -- use {
	-- -- 	'goolord/alpha-nvim',
	-- -- 	requires = { 'kyazdani42/nvim-web-devicons' },
	-- -- 	config = function ()
	-- -- 		require'alpha'.setup(require'alpha.themes.startify'.config)
	-- -- 	end
	-- -- }

	-- -- misc
	-- use {
	-- 	'neoclide/coc.nvim',
	-- 	branch = 'release'
	-- }
	-- use 'andweeb/presence.nvim'
	-- use 'notomo/gesture.nvim'


	-- use {
	-- 	'nvim-telescope/telescope.nvim',
	-- 	requires = { {'nvim-lua/plenary.nvim'} }
	-- }

	-- if packer_bootstrap then
	-- 	require('packer').sync()
	--  end
end)

