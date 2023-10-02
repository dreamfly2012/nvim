import pynvim


@pynvim.plugin
class MyPlugin:
    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.command("MyCommand", nargs="*", range="")
    def my_command(self, args, range):
        self.nvim.out_write(
            "MyCommand was called with args: {}\n".format(args))

    @pynvim.function("MyFunction", sync=True)
    def my_function(self, args):
        return "Hello from MyFunction"
