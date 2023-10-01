return {
    adapters = {
        type='executable',
        command = 'node',
        args = {os.getenv("HOME") .. "/vscode-php-debug/out/phpDebug.js"},
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
