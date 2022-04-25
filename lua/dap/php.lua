return {
    adapters = {
        type='executable',
        command = 'nodejs',
        args = {"/home/dreamfly/vscode-php-debug/out/phpDebug.js"},
    },
    configurations = {
        {
            name = "run current script",
            type = "php",
            request = "launch",
            port = 9000,
            cwd="${fileDirname}",
            program = "${file}",
            runtimeExecutable ="php"
        },
        {
            name="listen address",
            type="php",
            request="launch",
            port=9000,

        }
    }
}
