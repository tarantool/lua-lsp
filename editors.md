# Prerequisites
First of all, you need to make your text editor ready to work with LSP.
Some editors support this protocol internally, others support it via plugins.

## Important note

> backend - current LSP implementation for Tarantool/Lua (this repo).

Anyway, you need to specify the path for the editor to start the LSP server.
The editor will start a new process with the LSP backend, you don't need to
start it manually.

If you install the backend via a packet manager, you will get LSP installed and
available from the default environment.
```bash
# Command for the default LSP backend mode (stdin/stout)
tarantool-lsp server

# Command for the Websocket mode (see README.md)
tarantool-lsp ws
```

See the [Examples](#Examples) section for more details.

## Editors

### Visual Studio Code

Visual Studio Code implements language client support via an extension
[library][vscode]. If you have a working configuration, please contribute it!

[vscode]: https://www.npmjs.com/package/vscode-languageclient

### Atom-IDE

Atom, like VS Code, implements language client support via an extension
[library][atom-ide]. If you have a working configuration, please contribute it!

[atom-ide]: https://github.com/atom/atom-languageclient

### Sublime Text 3

Sublime has an [LSP plugin][st3]. See the [Examples](#Examples) section for
default configuration.

[st3]: https://github.com/tomv564/LSP

### Emacs

Emacs has a [package][emacs] to create language clients. If you have a working
configuration, please contribute it!

[emacs]: https://github.com/emacs-lsp/lsp-mode

## Examples

Default Sublime configuration looks like this:
```json
{
	"clients":
	{
		"tarantool-lsp":
		{
			"command":
			[
				"tarantool-lsp",
				"server"
			],
			"enabled": true,
			"languageId": "lua",
			"scopes": [
				"source.lua"
			],
			"syntaxes": [
				"Packages/Lua/Lua.sublime-syntax"
			]
		}
	}
}

```

For more details, please see the documentation for your editor -- or the editor's
LSP plugin.
