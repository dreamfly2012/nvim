local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { vim.v.errmsg, "WarningMsg" },
        { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
end
vim.opt.rtp:prepend(lazypath)

-- nvim-treesitter 的 main 分支(重写版)要求 Neovim >= 0.12,
-- 低版本 Neovim 使用冻结的 master 分支
local treesitter_branch = nil
if vim.fn.has("nvim-0.12") ~= 1 then
    treesitter_branch = "master"
end

require("lazy").setup({
    "windwp/nvim-autopairs",
    "folke/tokyonight.nvim",
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    -- 'numToStr/Comment.nvim',
    -- neodev.nvim 已停止维护且不再兼容 0.11+, 换成 lazydev.nvim
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    "lervag/vimtex",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "jwalton512/vim-blade",
    "nvim-tree/nvim-web-devicons",
    "mhartington/formatter.nvim",
    "akinsho/toggleterm.nvim",
    "ojroques/vim-oscyank",
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
    "nvim-lua/plenary.nvim",
    {
        "nvim-treesitter/nvim-treesitter",
        branch = treesitter_branch,
        build = ":TSUpdate",
    },
    "antoinemadec/FixCursorHold.nvim",
    "olimorris/neotest-phpunit",
    "nvim-telescope/telescope.nvim",
    "othree/html5.vim",
    "voldikss/vim-translator",
    "pangloss/vim-javascript",
    "evanleck/vim-svelte",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    "hotoo/pangu.vim",
    -- markdown
    {
        "godlygeek/tabular",
    },
    {
        "preservim/vim-markdown",
    },
    -- settings.lua 里配置了 mkdp_* 变量, 对应这个插件(需要 node + npm)
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = { "markdown" },
    },
    {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup {
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
    },
    {
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup {
            }
        end
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            require("dap.nvim-dap")
        end
    },
    -- 为代码调试提供内联文本
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = {
            "mfussenegger/nvim-dap"
        },
        config = function()
            require("dap.nvim-dap-virtual-text")
        end
    },
    -- 为代码调试提供 UI 界面
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap"
        },
        config = function()
            require("dap.nvim-dap-ui")
        end
    },
    "mattn/emmet-vim",
    "junegunn/fzf",
    "junegunn/fzf.vim",
    "windwp/nvim-ts-autotag",
    "ellisonleao/glow.nvim",
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        -- 详细的 nvim-tree 配置在 plugconfigs.lua 中
    },
    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            -- lsp_keymaps = false,
            -- other options
        },
        config = function(lp, opts)
            require("go").setup(opts)
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require('go.format').goimports()
                end,
                group = format_sync_grp,
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    { "nvim-lua/lsp-status.nvim" },
    {
        "SDGLBL/nvim-sync.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("nvim-sync").setup {
                -- sync_exe_filename default name of the sync executable
                sync_exe_filename = ".sync",
                -- enable_paths
                enable_paths = {},
                -- sync_exe_path path to the sync executable
                -- if not set, it will be searched in the project root path by default
                -- if not found, it will be searched in the system path
                -- if not found, it will return an error
                sync_exe_path = nil,
                -- Methods of detecting the root directory.
                -- if one is not detected, the other is used as fallback. You can also delete or rearangne the detection methods.
                detection_methods = { "pattern", "lsp" },
                -- All the patterns used to detect root dir, when **"pattern"** is in
                -- detection_methods
                patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json" },
                -- Table of lsp clients to ignore by name
                -- eg: { "efm", ... }
                ignore_lsp = {},
            }
        end,
    },
}, {
    git = {
        -- defaults for the `Lazy log` command
        -- log = { "-10" }, -- show the last 10 commits
        log = { "-8" }, -- show commits from the last 3 days
        timeout = 120, -- kill processes that take more than 2 minutes
        -- 默认使用 https 克隆, Windows/无 SSH key 的机器也能直接用;
        -- 如果你配置了 GitHub SSH key, 可以改回 "git@github.com:%s.git",
        url_format = "https://github.com/%s.git",

        -- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older git,
        -- then set the below to false. This should work, but is NOT supported and will
        -- increase downloads a lot.
        filter = true,
    },
})
