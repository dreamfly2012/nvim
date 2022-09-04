local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("i", "jk", "<ESC>", { silent = true })
-- Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
map('n', '<F2>', ":NvimTreeToggle<cr>",{})
map('n', ';f', ":FZF<cr>",{})
map('n', 'w=',":resize +3<cr>",{})
map('n', 'w-',' :resize -3<cr>',{})
map('n', 'w,',":vert resize -3<cr>",{})
map('n', 'w.',":vert resize +3<cr>",{})

map('n', 'ff',"<cmd>Telescope find_files<cr>",{})
map('n', 'fg',"<cmd>Telescope live_grep<cr>",{})
map('n', 'fb',"<cmd>Telescope buffers<cr>",{})
map('n', 'fh',"<cmd>Telescope help_tags<cr>",{})

-- nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
-- nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
-- nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
--  nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
