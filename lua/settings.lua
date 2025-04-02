vim.o.number = true
vim.o.textwidth = 80
vim.o.mouse = 'a'
vim.o.scrolloff = 10
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.spelllang = "en,cjk"
vim.o.ai = true
vim.o.si = true
vim.o.title = true
vim.o.titlestring = "%<%F - nvim"
vim.o.completeopt= "menu,preview,menuone,noselect"
vim.o.cursorline = true
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""
vim.g.translator_default_engines = {"bing","haici"}
vim.g.translator_target_lang = "zh"
vim.g.vim_markdown_fenced_languages = {"vim","js=javascript","go=golang","php","ts","lua","java","python","c","cpp"}
vim.g.vim_markdown_folding_disabled = 1
vim.g.mkdp_open_to_the_world = 1
vim.g.mkdp_echo_preview_url = 1
vim.o.undofile=true

vim.api.nvim_create_autocmd({'BufNewFile','BufRead'},{
    pattern = "*.hbs",
    callback = function()
        vim.bo.filetype = 'html'
    end,
})
