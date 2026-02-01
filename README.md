# LS for Avalonia
 Simple standalone Language Server for Avalonia XAML files suitable to lightweight editors like neovim and helix with support for completions and xaml formatting via xaml styler

- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Achlinux AUR](#archlinux-aur)
- [LSP Configuration](#lsp-configuration)
  - [Helix](#helix)
  - [Neovim](#neovim)
- [Instructions](#instructions)
  - [Previewer](#previewer)
- [Disclaimer](#disclaimer)

## Installation

### Build from Source

Prerequisites:
1. [.NET SDK 9.0][dotnet-sdk-9]
2. [just][just]

Works on:
- Linux
- Windows

Clone recursively and run `just install` recipe( `.local/bin` must be in your path)
```bash
git clone https://www.github.com/eugenenoble2005/ls-for-avalonia.git --recursive
cd avalonia-ls
just install
```


> On Windows:  
> Add `%LocalAppData%/avalonia-ls` to `PATH` environment variable e.g.
> ```powershell
> $env:Path += ";C:\Users\usrname\AppData\Local\avalonia-ls"
> ```

### Archlinux AUR

```bash
yay -S avalonia-ls-git
```

## LSP Configuration

### Helix

```toml
[language-server.avalonials]
command = "avalonia-ls"

[[language]]
name="xml"
scope="source.axaml"
injection-regex="axaml"
file-types=["axaml"]
language-servers=["avalonials"]
grammar="xml"
auto-format=false
formatter={command="xaml-styler",args=["--write-to-stdout" ,"--take-pipe"]}
```

### Neovim

```lua
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
	pattern = { "*.axaml" },
	callback = function(event)
		vim.lsp.start {
			name = "avalonia",
			cmd = { "avalonia-ls" },
			root_dir = vim.fn.getcwd(),
		}
	end
})
vim.filetype.add({
	extension = {
		axaml = "xml",
	},
})

```

## Instructions
For completions to work on an avalonia project, you must generate metadata and build. If you install with just, an avalonia-solution-parser executable will be installed
```bash
cd my-avalonia-project
# you should run the following generally in the directory with your .csproj or .fsproj files
avalonia-solution-parser .
dotnet build
```
You need to run `avalonia-solution-parser` to generate metadata just once. Completions should work afterwards

### Previewer
You can run a xaml previewer in a browser tab for any xaml file in your project:
```bash
avalonia-preview --file path/to/axaml/file
```
On supported terminal emulators like kitty, ghostty or wezterm, you can run the previewer directly inside the terminal. This is experimental and does not yet capture input like mouse and keyboard.
```bash
avalonia-preview --file path/to/axaml/file --target terminal
```


https://github.com/user-attachments/assets/32c9a183-2e48-44e5-8569-ca0da96d2f65

## Disclaimer
This project is not associated or endorsed by the developers of Avalonia.

[dotnet-sdk-9]:https://dotnet.microsoft.com/en-us/download/dotnet/9.0
[just]:https://github.com/casey/just
