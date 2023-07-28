function Todo()
    print("hello")
end

vim.api.nvim_create_user_command("Todo", Todo, {})
vim.keymap.set("n", "<c-l>", Todo)
function hello()
    local line = vim.api.nvim_get_current_line()
    print("Hello, " .. line)
end

function randomImg()
    local base = "https://picsum.photos/"
    local url = base .. "200"
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    local nline = line:sub(0, cursor[2]) .. url .. line:sub(cursor[2] + 1)

    vim.api.nvim_set_current_line(nline)
    vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + url:len() })
end

-- 注册命令：在 Neovim 中注册 "Hello" 命令，使其调用 hello 函数
vim.api.nvim_command('command! Hello lua hello()')
vim.api.nvim_command('command! Randomimg lua randomImg()')
