local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').init({
    git = {
        default_url_format = 'git@github.com:%s'
    }
})
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    }
    use 'lervag/vimtex'
    use {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip'
    }
    use {
        'jwalton512/vim-blade'
    }
    use {
        'nvim-tree/nvim-web-devicons'
    }
    -- terminal
    use {"akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup()
    end}
    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            'olimorris/neotest-phpunit',
        }
    }
    --theme
    use {
        'dracula/vim',
    }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { {
            'nvim-lua/plenary.nvim',
            'nvim-lua/popup.nvim',
        } }
    }
    -- code runner
    use { 'michaelb/sniprun', run = 'bash install.sh' }
    -- screenshot
    use {'asamonik/nvim-screenshot', run = 'go build' }
    use {'segeljakt/vim-silicon'}
    use {
        'ekickx/clipboard-image.nvim'
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
        'hotoo/pangu.vim'
    }
    -- markdown
    use {
        'godlygeek/tabular',
        'preservim/vim-markdown',
    }
    use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })
    use {
        'folke/zen-mode.nvim',
        config = function()
            require("zen-mode").setup{
                window = {
                    width = 90,
                    options = {
                        -- signcolumn = "no", -- disable signcolumn
                        number = false, -- disable number column
                        relativenumber = false, -- disable relative numbers
                        cursorline = false, -- disable cursorline
                        cursorcolumn = false, -- disable cursor column
                        -- foldcolumn = "0", -- disable fold column
                        -- list = false, -- disable whitespace characters
                    }
                }
            }
        end
    }
    use {
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup {
            }
        end
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
        'mattn/emmet-vim'
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
    if packer_bootstrap then
        require('packer').sync()
    end
end)
