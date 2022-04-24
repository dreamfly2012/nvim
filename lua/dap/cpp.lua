return {
    adapters = {
        type = 'executable',
        command = '/home/dreamfly/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
        id = "cpp",
        name = "cpp"
    },
    configurations = {
        {
            name = "Launch file",
            type = "cpp",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = true,
        },
        {
            name = 'Attach to gdbserver :1234',
            type = 'cpp',
            request = 'launch',
            MIMode = 'gdb',
            miDebuggerServerAddress = 'localhost:1234',
            miDebuggerPath = '/usr/bin/gdb',
            cwd = '${workspaceFolder}',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
        },
    }
}
