-- python3 -m pip install debugpy
return {
    adapters = {
        type = "executable",
        -- Windows 上的命令是 python, 其他平台通常是 python3
        command = (vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1) and "python" or "python3",
        args = {"-m", "debugpy.adapter"}
    },
    configurations = {
        {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            pythonPath = function()
                return vim.g.python_path
            end
        }
    }
}
