return {
    adapters = {
        type='executable',
        command = 'node',
        -- 跨平台的 home 目录, Windows 上 $HOME 通常不存在
        args = {vim.fn.expand('~/vscode-php-debug/out/phpDebug.js')},
    },
    configurations = {
        {
            name = "run current script",
            type = "php",
            request = "launch",
            port = 9003,
            cwd="${fileDirname}",
            program = "${file}",
            runtimeExecutable ="php"
        },
        {
            name="listen address",
            type="php",
            request="launch",
            port=9003,
        }
    }
}
