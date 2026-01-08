#!/bin/bash
#

mkdir -p /home/$USER/.local/bin

export PATH=$PATH:/home/$USER/.local/bin
echo current path: $PATH
echo add 'export PATH=$PATH:/home/$USER/.local/bin' to .bashrc

cd /home/$USER/.local

# install gah
bash -c "$(curl -fsSL https://raw.githubusercontent.com/get-gah/gah/refs/heads/master/tools/install.sh)"

# lazygit 
gah install lazygit

# neovim
gah install neovim/neovim
#mkdir -p nvim
#cd nvim
#wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
#tar -xf nvim-linux-x86_64.tar.gz
#cd /home/$USER/.local/bin
#ln -s /home/$USER/.local/nvim/nvim-linux-x86_64/bin/nvim nvim

# ripgrep
gah install BurntSushi/ripgrep
#mkdir -p /home/$USER/.local/ripgrep
#cd /home/$USER/.local/ripgrep
#wget https://github.com/BurntSushi/ripgrep/releases/download/15.1.0/ripgrep-15.1.0-x86_64-unknown-linux-musl.tar.gz
#tar -xf ripgrep-15.1.0-x86_64-unknown-linux-musl.tar.gz
#cd /home/$USER/.local/bin
#ln -s /home/$USER/.local/ripgrep/ripgrep-15.1.0-x86_64-unknown-linux-musl/rg rg

# fd-find
gah install sharkdp/fd
#mkdir -p /home/$USER/.local/fd-find
#cd /home/$USER/.local/fd-find
#wget https://github.com/sharkdp/fd/releases/download/v10.3.0/fd-v10.3.0-x86_64-unknown-linux-musl.tar.gz
#tar -xf fd-v10.3.0-x86_64-unknown-linux-musl.tar.gz
#cd /home/$USER/.local/bin
#ln -s /home/$USER/.local/fd-find/fd-v10.3.0-x86_64-unknown-linux-musl/fd fd

# clipboard
# https://askubuntu.com/a/1486875

# luarocks
gah install luarocks/luarocks
#mkdir -p /home/$USER/.local/luarocks
#cd /home/$USER/.local/luarocks
#wget https://luarocks.github.io/luarocks/releases/luarocks-3.12.2-linux-x86_64.zip
#unzip luarocks-3.12.2-linux-x86_64.zip
#cd /home/$USER/.local/bin
#ln -s /home/$USER/.local/luarocks/luarocks-3.12.2-linux-x86_64/luarocks luarocks
#

# kickstart
#git clone https://github.com/retogerber/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# air (R lsp)
mkdir -p /home/$USER/.local/air
cd /home/$USER/.local/air
curl -LsSf https://github.com/posit-dev/air/releases/latest/download/air-installer.sh | sh

# treesitter cli
gah install tree-sitter/tree-sitter
#mkdir -p /home/$USER/.local/treesitter-cli
#cd /home/$USER/.local/treesitter-cli
#wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.3/tree-sitter-linux-x64.gz
#gunzip tree-sitter-linux-x64.gz
#chmod +x tree-sitter-linux-x64
#cd /home/$USER/.local/bin
#ln -s /home/$USER/.local/treesitter-cli/tree-sitter-linux-x64 tree-sitter-cli

# quarto
gah install quarto-dev/quarto-cli
#mkdir -p /home/$USER/.local/quarto
#cd /home/$USER/.local/quarto
#wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.26/quarto-1.8.26-linux-amd64.tar.gz
#tar -xvzf quarto-1.8.26-linux-amd64.tar.gz
#ln -s /home/$USER/.local/quarto/quarto-1.8.26/bin/quarto /home/$USER/.local/bin/quarto

# kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -s /home/$USER/.local/kitty.app/bin/kitty /home/$USER/.local/bin/kitty

# nerdfonts
mkdir -p /home/$USER/.local/share/fonts
cd /home/$USER/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d /home/$USER/.local/share/fonts/JetBrainsMono
fc-cache -fv

# yazi
gah install sxyazi/yazi
#mkdir -p /home/$USER/.local/yazi
#cd /home/$USER/.local/yazi
#wget https://github.com/sxyazi/yazi/releases/download/v26.1.4/yazi-x86_64-unknown-linux-gnu.zip
#unzip yazi-x86_64-unknown-linux-gnu.zip
#ln -s /home/$USER/.local/yazi/yazi-x86_64-unknown-linux-gnu/yazi /home/$USER/.local/bin/yazi
