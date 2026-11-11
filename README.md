# kickstart-modular.nvim

## Introduction

*This is a fork of [nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) that moves from a single file to a multi file configuration.*

A starting point for Neovim that is:

* Small
* Modular
* Completely Documented

**NOT** a Neovim distribution, but instead a starting point for your configuration.

## Installation

### Install Neovim

Kickstart.nvim targets *only* the latest
['stable'](https://github.com/neovim/neovim/releases/tag/stable) and latest
['nightly'](https://github.com/neovim/neovim/releases/tag/nightly) of Neovim.
If you are experiencing issues, please make sure you have at least the latest
stable version. Most likely, you want to install neovim via a [package
manager](https://github.com/neovim/neovim/blob/master/INSTALL.md#install-from-package).
To check your neovim version, run `nvim --version` and make sure it is not
below the latest
['stable'](https://github.com/neovim/neovim/releases/tag/stable) version. If
your chosen install method only gives you an outdated version of neovim, find
alternative [installation methods below](#alternative-neovim-installation-methods).

### Install External Dependencies

External Requirements:
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation),
  [fd-find](https://github.com/sharkdp/fd#installation)
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on the platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true
- Emoji fonts (Ubuntu only, and only if you want emoji!) `sudo apt install fonts-noto-color-emoji`
- Language Setup:
  - If you want to write Typescript, you need `npm`
  - If you want to write Golang, you will need `go`
  - etc.

> [!NOTE]
> See [Install Recipes](#Install-Recipes) for additional Windows and Linux specific notes
> and quick install snippets

### Install Kickstart

> [!NOTE]
> [Backup](#FAQ) your previous configuration (if any exists)

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%localappdata%\nvim\` |
| Windows (powershell)| `$env:LOCALAPPDATA\nvim\` |

#### Recommended Step

Create your own copy of this repo using GitHub's
["Use this template"](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)
button so that you have your own copy that you can modify, then install by
cloning your new repo to your machine using one of the commands below,
depending on your OS.

Alternatively, you can [fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
this repo if you prefer an easy upstream sync path (e.g., keeping your config
on a separate branch and fast-forwarding `master` from upstream). See the
[discussion in #1740](https://github.com/nvim-lua/kickstart.nvim/issues/1740)
for the tradeoffs between the two approaches.

> [!NOTE]
> Your repo's URL will be something like this:
> `https://github.com/<your_github_username>/kickstart-modular.nvim.git`

You likely want to remove `nvim-pack-lock.json` from your repo's `.gitignore`
file too - it's ignored in the kickstart repo to make maintenance easier, but
it's recommended to track it in version control (see `:help vim.pack-lockfile`).

#### Clone kickstart.nvim

> [!NOTE]
> If following the recommended step above (i.e., creating your own repo from
> the template or fork), replace `dam9000` with `<your_github_username>`
> in the commands below

<details><summary> Linux and Mac </summary>

```sh
git clone https://github.com/dam9000/kickstart-modular.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```
git clone https://github.com/dam9000/kickstart-modular.nvim.git "%localappdata%\nvim"
```

If you're using `powershell.exe`

```
git clone https://github.com/dam9000/kickstart-modular.nvim.git "${env:LOCALAPPDATA}\nvim"
```

</details>

### Post Installation

Start Neovim

```sh
nvim
```

That's it! `vim.pack` will install all the plugins from your config. Use
`:lua vim.pack.update(nil, { offline = true })` to inspect plugin state and
`:lua vim.pack.update()` to fetch updates (`:write` applies updates, `:quit`
cancels them).

Plugin modules in `lua/custom/plugins/` are loaded at startup after the core
plugins. Their loading order is unspecified; require modules explicitly in
`lua/plugins.lua` instead of using the loader if they depend on a particular
order.

### R and Quarto over SSH

R.nvim runs R in a Neovim terminal **on the server**; the local Kitty
installation is not used as a remote terminal executable. Install R >= 4.1,
`make`, a C compiler, and the tree-sitter CLI on the server. `vim.pack`
installs the pinned R.nvim release and its submodules; R.nvim builds
`nvimcom`, `rnvimserver`, and the `rout` parser when needed. The R, CSV,
Markdown and YAML parsers are managed by nvim-treesitter. Run `:checkhealth r`
and `:RDebugInfo` if startup fails. If an `.Rprofile` sets `defaultPackages`,
it must include `nvimcom` for R.nvim sessions (see `:help nvimcom-not-loaded`).

Open an `.R`, `.qmd`, or `.Rmd` file and use `Space Rs` to start or reopen R,
`Space Rq` to quit it, and `Space Ro` for the object browser. `Space rl` sends
the current line and visual `Space r` sends the selection. In a Quarto R
chunk, `Space rc` sends the current cell, `Space rA` sends all cells of the
current language, and visual `Space R` sends a range. These all use the same
R.nvim session; start it first. Python remains on Iron, including its existing
Python-specific paste formatting and REPL controls. Use `:RMapsDesc` to inspect
R.nvim's mappings; its default key combinations are disabled to avoid
colliding with this configuration. R.nvim supplies R completion while the
existing R language server supplies diagnostics and other LSP features.

For browser-based output, forward loopback ports from the **local** machine
when connecting (replace the hostname and user):

```sh
ssh -L 8765:127.0.0.1:8765 -L 8766:127.0.0.1:8766 \
    -L 4200:127.0.0.1:4200 user@server
```

In the R console, after installing the R package `httpgd`, start a graphics
device and generate a plot:

```r
httpgd::hgd(host = "127.0.0.1", port = 8765)
plot(mtcars)
```

Open the **complete URL including its token** printed by httpgd in the local
browser. The browser provides plot history, zooming and export; the R session
must remain running. This is not a graphics device for HTML widgets.

For interactive widgets such as plotly or leaflet, install `htmlwidgets`, the
widget package and Pandoc on the server. Start a static server in a separate
remote shell:

```sh
install -d -m 700 "$HOME/.cache/r-nvim-widgets"
python3 -m http.server 8766 --bind 127.0.0.1 --directory "$HOME/.cache/r-nvim-widgets"
```

In R, save a widget and open `http://127.0.0.1:8766/widget.html` locally:

```r
widget <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
htmlwidgets::saveWidget(widget, file.path(Sys.getenv("HOME"), ".cache/r-nvim-widgets/widget.html"), selfcontained = TRUE)
```

Save again and refresh the browser after changes. Widgets requiring a live R
backend (for example Shiny) instead need their own server and forwarded port.
For Quarto preview, `Space qp` starts a loopback-only server on port 4200
without opening a browser when connected via SSH; open the URL printed in the
preview terminal on the local machine. Install Quarto and the appropriate R
packages (for example `knitr`, `rmarkdown`, and `quarto`) for rendering.

These ports are examples: choose unused ports and update the SSH forwarding
and server commands together (change port 4200 in
`lua/custom/plugins/quarto.lua` for Quarto). Loopback-only servers are still reachable by
other users on the same server; httpgd's token protects its viewer, but the
static widget and Quarto servers have no authentication. Do not serve
sensitive output on a shared server without additional access controls.

#### Read The Friendly Documentation

Read through the `init.lua` file in your configuration folder for more
information about extending and exploring Neovim. That also includes
examples of adding popularly requested plugins.

> [!NOTE]
> For more information about a particular plugin check its repository's documentation.


### Getting Started

[The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o)

### FAQ

* What should I do if I already have a pre-existing Neovim configuration?
  * You should back it up and then delete all associated files.
  * This includes your existing init.lua and the Neovim files in `~/.local`
    which can be deleted with `rm -rf ~/.local/share/nvim/`
* Can I keep my existing configuration in parallel to kickstart?
  * Yes! You can use [NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME)`=nvim-NAME`
    to maintain multiple configurations. For example, you can install the kickstart
    configuration in `~/.config/nvim-kickstart` and create an alias:
    ```
    alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
    ```
    When you run Neovim using `nvim-kickstart` alias it will use the alternative
    config directory and the matching local directory
    `~/.local/share/nvim-kickstart`. You can apply this approach to any Neovim
    distribution that you would like to try out.
* What if I want to "uninstall" this configuration:
  * Remove your config directory and local data directory (for example,
    `~/.config/nvim` and `~/.local/share/nvim`).
* Why is the kickstart `init.lua` a single file? Wouldn't it make sense to split it into multiple files?
  * The main purpose of kickstart is to serve as a teaching tool and a reference
    configuration that someone can easily use to `git clone` as a basis for their own.
    As you progress in learning Neovim and Lua, you might consider splitting `init.lua`
    into smaller parts. A fork of kickstart that does this while maintaining the
    same functionality is available here:
    * [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim)
  * *NOTE: This is the fork that splits the configuration into smaller parts.*
    The original repo with the single `init.lua` file is available here:
    * [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
  * Discussions on this topic can be found here:
    * [Restructure the configuration](https://github.com/nvim-lua/kickstart.nvim/issues/218)
    * [Reorganize init.lua into a multi-file setup](https://github.com/nvim-lua/kickstart.nvim/pull/473)

### Install Recipes

Below you can find OS specific install instructions for Neovim and dependencies.

After installing all the dependencies continue with the [Install Kickstart](#install-kickstart) step.

#### Windows Installation

<details><summary>Windows with Microsoft C++ Build Tools and CMake</summary>
Kickstart's default config is make-only for `telescope-fzf-native.nvim`.
If `make` is unavailable, the plugin is skipped.

Recommended: install `make` (see the chocolatey section below).

If you want a CMake-only setup, customize these two modules:

1. In `lua/kickstart/plugins/telescope.lua`, include `telescope-fzf-native.nvim` when `cmake` is available:

```lua
if vim.fn.executable 'make' == 1 or vim.fn.executable 'cmake' == 1 then
  table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim')
end
```

2. In the `PackChanged` hook in `lua/pack.lua`, use CMake when `make` is unavailable:

```lua
if name == 'telescope-fzf-native.nvim' then
  if vim.fn.executable 'make' == 1 then
    run_build(name, { 'make' }, ev.data.path)
  elseif vim.fn.executable 'cmake' == 1 then
    run_build(name, { 'cmake', '-S.', '-Bbuild', '-DCMAKE_BUILD_TYPE=Release' }, ev.data.path)
    run_build(name, { 'cmake', '--build', 'build', '--config', 'Release', '--target', 'install' }, ev.data.path)
  end
  return
end
```

See `telescope-fzf-native` documentation for [build details](https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation).
</details>
<details><summary>Windows with gcc/make using chocolatey</summary>
Alternatively, one can install gcc and make which don't require changing the config,
the easiest way is to use choco:

1. install [chocolatey](https://chocolatey.org/install)
either follow the instructions on the page or use winget,
run in cmd as **admin**:
```
winget install --accept-source-agreements chocolatey.chocolatey
```

2. install all requirements using choco, exit the previous cmd and
open a new one so that choco path is set, and run in cmd as **admin**:
```
choco install -y neovim git ripgrep wget fd unzip gzip mingw make tree-sitter
```
</details>
<details><summary>WSL (Windows Subsystem for Linux)</summary>

```
wsl --install
wsl
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep fd-find tree-sitter-cli unzip git xclip neovim
```
</details>

#### Linux Install
<details><summary>Ubuntu Install Steps</summary>

```
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep fd-find tree-sitter-cli unzip git xclip neovim
```
</details>
<details><summary>Debian Install Steps</summary>

```
sudo apt update
sudo apt install make gcc ripgrep fd-find tree-sitter-cli unzip git xclip curl

# Now we install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
```
</details>
<details><summary>Fedora Install Steps</summary>

```
sudo dnf install -y gcc make git ripgrep fd-find tree-sitter-cli unzip neovim
```
</details>

<details><summary>Arch Install Steps</summary>

```
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd tree-sitter-cli unzip neovim
```
</details>

<details><summary>Alpine Install Steps</summary>

> [!CAUTION]
> Neovim works fine on Alpine, but some tooling appears incompatible with musl
> (lua-language-server, etc., check `:Mason` or `:MasonLog`).
> Quickfix Lua-LSP-Support: `:%s/lua_ls/emmylua_ls`

```shell
sudo apk add gcc make git fd ripgrep tree-sitter-cli unzip bash gzip curl musl-dev neovim-doc neovim
```

</details>

### Alternative neovim installation methods

For some systems it is not unexpected that the [package manager installation
method](https://github.com/neovim/neovim/blob/master/INSTALL.md#install-from-package)
recommended by neovim is significantly behind. If that is the case for you,
pick one of the following methods that are known to deliver fresh neovim versions very quickly.
They have been picked for their popularity and because they make installing and updating
neovim to the latest versions easy. You can also find more detail about the
available methods being discussed
[here](https://github.com/nvim-lua/kickstart.nvim/issues/1583).


<details><summary>Bob</summary>

[Bob](https://github.com/MordechaiHadad/bob) is a Neovim version manager for
all platforms. Simply install
[rustup](https://rust-lang.github.io/rustup/installation/other.html),
and run the following commands:

```bash
rustup default stable
rustup update stable
cargo install bob-nvim
bob use stable
```

</details>

<details><summary>Homebrew</summary>

[Homebrew](https://brew.sh) is a package manager popular on Mac and Linux.
Simply install using [`brew install`](https://formulae.brew.sh/formula/neovim).

</details>

<details><summary>Flatpak</summary>

Flatpak is a package manager for applications that allows developers to package their applications
just once to make it available on all Linux systems. Simply [install flatpak](https://flatpak.org/setup/)
and setup [flathub](https://flathub.org/setup) to [install neovim](https://flathub.org/apps/io.neovim.nvim).

</details>

<details><summary>asdf and mise-en-place</summary>

[asdf](https://asdf-vm.com/) and [mise](https://mise.jdx.dev/) are tool version managers,
mostly aimed towards project-specific tool versioning. However both support managing tools
globally in the user-space as well:

<details><summary>mise</summary>

[Install mise](https://mise.jdx.dev/getting-started.html), then run:

```bash
mise plugins install neovim
mise use neovim@stable
```

</details>

<details><summary>asdf</summary>

[Install asdf](https://asdf-vm.com/guide/getting-started.html), then run:

```bash
asdf plugin add neovim
asdf install neovim stable
asdf set neovim stable --home
asdf reshim neovim
```

</details>

</details>
