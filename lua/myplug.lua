function Todo()
    print("hello")
end

vim.api.nvim_create_user_command("Todo", Todo, {})
vim.keymap.set("n", "<c-l>", Todo)
