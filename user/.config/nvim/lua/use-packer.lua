local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[set packpath+=$XDG_DATA_HOME/nvim/site]]

return require('packer').startup(function()
	use 'wbthomason/packer.nvim'

	-- status lines
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}

	-- file explorers
	use 'preservim/nerdtree'
	-- use {
	-- 	'kyazdani42/nvim-tree.lua',
	-- 	requires = {
	-- 		'kyazdani42/nvim-web-devicons',
	-- 	},
	-- 	tag = 'nightly' -- optional, updated every week. (see issue #1193)
	-- }

	-- formatting
	use 'gpanders/editorconfig.nvim'

	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}

	use {
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
		require("todo-comments").setup {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
		end
	}

	-- startup
	use 'startup-nvim/startup.nvim'
	-- use {
	-- 	'goolord/alpha-nvim',
	-- 	requires = { 'kyazdani42/nvim-web-devicons' },
	-- 	config = function ()
	-- 		require'alpha'.setup(require'alpha.themes.startify'.config)
	-- 	end
	-- }

	-- misc
	use {
		'neoclide/coc.nvim',
		branch = 'release'
	}
	use 'andweeb/presence.nvim'
	use 'notomo/gesture.nvim'


	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	if packer_bootstrap then
		require('packer').sync()
	 end
end)

