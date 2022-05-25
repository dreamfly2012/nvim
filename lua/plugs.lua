local use = require('packer').use
require('packer').init({
    git = {
        default_url_format = 'git@github.com:%s'
    }
})
require('packer').startup(function()
	use {'wbthomason/packer.nvim'}
	use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
    use {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp',

        'honza/vim-snippets',
        'dcampos/nvim-snippy',
        'dcampos/cmp-snippy',
    }
    use {
        'othree/html5.vim'
    }
    use {
        'voldikss/vim-translator'
    }
    use{
        'pangloss/vim-javascript'
    }
    use{
        'evanleck/vim-svelte', branch =  'main'
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use {
        'windwp/nvim-autopairs'
    }
    use {
        'hotoo/pangu.vim'
    }
    -- markdown
    use {
        'godlygeek/tabular',
        'preservim/vim-markdown',
        'junegunn/goyo.vim',
        'junegunn/limelight.vim'
    }
    use {
        "mfussenegger/nvim-dap",
        config = function()
            require("dap.nvim-dap")
        end
    }
    -- 为代码调试提供内联文本
    use {
        "theHamsta/nvim-dap-virtual-text",
        requires = {
            "mfussenegger/nvim-dap"
        },
        config = function()
            require("dap.nvim-dap-virtual-text")
        end
    }
    -- 为代码调试提供 UI 界面
    use {
        "rcarriga/nvim-dap-ui",
        requires = {
            "mfussenegger/nvim-dap"
        },
        config = function()
            require("dap.nvim-dap-ui")
        end
    }
    use {
        'akinsho/toggleterm.nvim'
    }
    use {
        'mattn/emmet-vim'
    }
    use {
        'github/copilot.vim'
    }
    use {
        'junegunn/fzf',
        'junegunn/fzf.vim'
    }
    use {
        'windwp/nvim-ts-autotag'
    }
    use {"ellisonleao/glow.nvim"}
	use {
		'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons',
		},
		config = function() require'nvim-tree'.setup {} end
	}
	use 'Mofiqul/dracula.nvim'
    use 'L3MON4D3/LuaSnip'
	use { 'tami5/lspsaga.nvim' }
	use {
        'crispgm/nvim-go',
		requires = {
			'nvim-lua/plenary.nvim',
			'nvim-lua/popup.nvim'
		},
		config = function() require'go'.setup{} end
	}
	use { 'nvim-treesitter/nvim-treesitter'}
	use { 'nvim-lua/lsp-status.nvim'}
end)
