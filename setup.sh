#!/bin/bash
#
#
LOCAL_INSTALL_DIR=/tachyon/groups/scratch/gturco/gerbreto/.local

mkdir -p ${LOCAL_INSTALL_DIR}/bin

export PATH=$PATH:${LOCAL_INSTALL_DIR}/bin
echo current path: $PATH
echo add 'export PATH=$PATH:${LOCAL_INSTALL_DIR}/bin' to .bashrc

cd ${LOCAL_INSTALL_DIR}

# install gah
bash -c "$(curl -fsSL https://raw.githubusercontent.com/get-gah/gah/refs/heads/master/tools/install.sh)"

# lazygit
gah install lazygit

# neovim
#gah install neovim/neovim
mkdir -p nvim
cd nvim
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -xf nvim-linux-x86_64.tar.gz
cd ${LOCAL_INSTALL_DIR}/bin
ln -s ${LOCAL_INSTALL_DIR}/nvim/nvim-linux-x86_64/bin/nvim nvim

# link kickstart config
cd /tachyon/groups/scratch/gturco/gerbreto/.config
ln -s /tachyon/groups/scratch/gturco/gerbreto/software/kickstart-modular.nvim nvim

# ripgrep
gah install BurntSushi/ripgrep
#mkdir -p ${LOCAL_INSTALL_DIR}/ripgrep
#cd ${LOCAL_INSTALL_DIR}/ripgrep
#wget https://github.com/BurntSushi/ripgrep/releases/download/15.1.0/ripgrep-15.1.0-x86_64-unknown-linux-musl.tar.gz
#tar -xf ripgrep-15.1.0-x86_64-unknown-linux-musl.tar.gz
#cd ${LOCAL_INSTALL_DIR}/bin
#ln -s ${LOCAL_INSTALL_DIR}/ripgrep/ripgrep-15.1.0-x86_64-unknown-linux-musl/rg rg

# fd-find
gah install sharkdp/fd
#mkdir -p ${LOCAL_INSTALL_DIR}/fd-find
#cd ${LOCAL_INSTALL_DIR}/fd-find
#wget https://github.com/sharkdp/fd/releases/download/v10.3.0/fd-v10.3.0-x86_64-unknown-linux-musl.tar.gz
#tar -xf fd-v10.3.0-x86_64-unknown-linux-musl.tar.gz
#cd ${LOCAL_INSTALL_DIR}/bin
#ln -s ${LOCAL_INSTALL_DIR}/fd-find/fd-v10.3.0-x86_64-unknown-linux-musl/fd fd

# clipboard
# https://askubuntu.com/a/1486875

# luarocks
gah install luarocks/luarocks --tag=v3.12.2
#mkdir -p ${LOCAL_INSTALL_DIR}/luarocks
#cd ${LOCAL_INSTALL_DIR}/luarocks
#wget https://luarocks.github.io/luarocks/releases/luarocks-3.12.2-linux-x86_64.zip
#unzip luarocks-3.12.2-linux-x86_64.zip
#cd ${LOCAL_INSTALL_DIR}/bin
#ln -s ${LOCAL_INSTALL_DIR}/luarocks/luarocks-3.12.2-linux-x86_64/luarocks luarocks
#

# kickstart
#git clone https://github.com/retogerber/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# air (R lsp)
mkdir -p ${LOCAL_INSTALL_DIR}/air
cd ${LOCAL_INSTALL_DIR}/air
curl -LsSf https://github.com/posit-dev/air/releases/latest/download/air-installer.sh | sh

# treesitter cli
#gah install tree-sitter/tree-sitter
mkdir -p ${LOCAL_INSTALL_DIR}/treesitter-cli
cd ${LOCAL_INSTALL_DIR}/treesitter-cli
wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.3/tree-sitter-linux-x64.gz
gunzip tree-sitter-linux-x64.gz
chmod +x tree-sitter-linux-x64
cd ${LOCAL_INSTALL_DIR}/bin
ln -s ${LOCAL_INSTALL_DIR}/treesitter-cli/tree-sitter-linux-x64 tree-sitter-cli

# quarto
gah install quarto-dev/quarto-cli
#mkdir -p ${LOCAL_INSTALL_DIR}/quarto
#cd ${LOCAL_INSTALL_DIR}/quarto
#wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.26/quarto-1.8.26-linux-amd64.tar.gz
#tar -xvzf quarto-1.8.26-linux-amd64.tar.gz
#ln -s ${LOCAL_INSTALL_DIR}/quarto/quarto-1.8.26/bin/quarto ${LOCAL_INSTALL_DIR}/bin/quarto

# kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -s ${LOCAL_INSTALL_DIR}/kitty.app/bin/kitty ${LOCAL_INSTALL_DIR}/bin/kitty
## add to desktop
mkdir -p ${LOCAL_INSTALL_DIR}/desktop
cat <<EOF >kitty.desktop
[Desktop Entry]
Name=Kitty
Comment=Launch kitty
Exec=/home/gerbreto/.local/bin/kitty
Icon=/home/gerbreto/.local/kitty.app/share/icons/hicolor/scalable/apps/kitty.svg
Terminal=false
Type=Application
Categories=Utility;
EOF
chmod +x kitty.desktop
mkdir -p ${LOCAL_INSTALL_DIR}/share/applications
cd ${LOCAL_INSTALL_DIR}/share/applications
ln -s ../../desktop/kitty.desktop kitty.desktop

# nerdfonts
mkdir -p ${LOCAL_INSTALL_DIR}/share/fonts
cd ${LOCAL_INSTALL_DIR}/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ${LOCAL_INSTALL_DIR}/share/fonts/JetBrainsMono
fc-cache -fv

# yazi
cd ${LOCAL_INSTALL_DIR}
gah install sxyazi/yazi
#mkdir -p ${LOCAL_INSTALL_DIR}/yazi
#cd ${LOCAL_INSTALL_DIR}/yazi
#wget https://github.com/sxyazi/yazi/releases/download/v26.1.4/yazi-x86_64-unknown-linux-gnu.zip
#unzip yazi-x86_64-unknown-linux-gnu.zip
#ln -s ${LOCAL_INSTALL_DIR}/yazi/yazi-x86_64-unknown-linux-gnu/yazi ${LOCAL_INSTALL_DIR}/bin/yazi
#
# copy the following to .bashrc:
#function y() {
#	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
#	command yazi "$@" --cwd-file="$tmp"
#	IFS= read -r -d '' cwd < "$tmp"
#	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
#	rm -f -- "$tmp"
#}

# duckdb
curl https://install.duckdb.org | sh
# yazi piper
ya pkg add yazi-rs/plugins:piper
# bunny
ya pkg add stelcodes/bunny

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# cmake for poppler

cd ${LOCAL_INSTALL_DIR}
wget https://github.com/Kitware/CMake/releases/download/v4.2.3/cmake-4.2.3-linux-x86_64.tar.gz
tar xf cmake-4.2.3-linux-x86_64.tar.gz
# poppler
wget https://poppler.freedesktop.org/poppler-26.02.0.tar.xz
tar -xf poppler-26.02.0.tar.xz
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=${LOCAL_INSTALL_DIR} -DENABLE_UTILS=ON -DENABLE_GPGME=OFF -DENABLE_QT5=OFF -DENABLE_QT6=OFF
make -j32
make install

# nvm
mkdir -p ${LOCAL_INSTALL_DIR}/nvm
export NVM_DIR="${LOCAL_INSTALL_DIR}/nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
# npm
nvm install --lts

# zotero
cd ${LOCAL_INSTALL_DIR}
wget https://download.zotero.org/client/release/8.0.3/Zotero-8.0.3_linux-x86_64.tar.xz
tar -xf Zotero-8.0.3_linux-x86_64.tar.xz
cd ${LOCAL_INSTALL_DIR}/bin
ln -s ${LOCAL_INSTALL_DIR}/Zotero_linux-x86_64/zotero ${LOCAL_INSTALL_DIR}/bin/zotero
mkdir -p ${LOCAL_INSTALL_DIR}/desktop
cat <<EOF >zotero.desktop
[Desktop Entry]
Name=Zotero
Comment=Launch zotero
Exec=/home/gerbreto/.local/bin/zotero
Icon=/home/gerbreto/.local/Zotero_linux-x86_64/icons/icon128.png
Terminal=false
Type=Application
Categories=Utility;
EOF
chmod +x zotero.desktop
cd ${LOCAL_INSTALL_DIR}/share/applications
ln -s ../../desktop/zotero.desktop zotero.desktop

# obsidian (from: https://obsidian.md/download)
mkdir -p ${LOCAL_INSTALL_DIR}/obsidian
cd ${LOCAL_INSTALL_DIR}/obsidian
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.11.7/Obsidian-1.11.7.AppImage
chmod +x Obsidian-1.11.7.AppImage
./Obsidian-1.11.7.AppImage
cd ${LOCAL_INSTALL_DIR}/bin
echo "/home/gerbreto/.local/obsidian/squashfs-root/obsidian --no-sandbox" >obsidian
chmod +x obsidian
## add to desktop
mkdir -p ${LOCAL_INSTALL_DIR}/desktop
cat <<EOF >obsidian.desktop
[Desktop Entry]
Name=Obsidian
Comment=Launch obsidian
Exec=/home/gerbreto/.local/bin/obsidian
Icon=/home/gerbreto/.local/obsidian/squashfs-root/usr/share/icons/hicolor/512x512/apps/obsidian.png
Terminal=false
Type=Application
Categories=Utility;
EOF
chmod +x obsidian.desktop
mkdir -p ${LOCAL_INSTALL_DIR}/share/applications
cd ${LOCAL_INSTALL_DIR}/share/applications
ln -s ../../desktop/obsidian.desktop obsidian.desktop

# html2text
mkdir -p ${LOCAL_INSTALL_DIR}/html2textp
cd ${LOCAL_INSTALL_DIR}/html2textp
uv init
uv add html2text beautifulsoup4 requests chafa.py pillow numpy opencv-python
cd ${LOCAL_INSTALL_DIR}/bin
ln -s ${LOCAL_INSTALL_DIR}/html2textp/.venv/bin/html2text html2text

# chafa
mkdir -p ${LOCAL_INSTALL_DIR}/chafa
cd ${LOCAL_INSTALL_DIR}/chafa
wget https://hpjansson.org/chafa/releases/static/chafa-1.18.1-1-x86_64-linux-gnu.tar.gz
tar -xf chafa-1.18.1-1-x86_64-linux-gnu.tar.gz
cd ${LOCAL_INSTALL_DIR}/bin
ln -s ${LOCAL_INSTALL_DIR}/chafa/chafa-1.18.1-1-x86_64-linux-gnu/chafa chafa

# glow
gah install charmbracelet/glow

## glibc
#mkdir -p ${LOCAL_INSTALL_DIR}/glibc
#cd ${LOCAL_INSTALL_DIR}/glibc
#wget http://ftp.gnu.org/gnu/libc/glibc-2.39.tar.gz
#tar -xvf glibc-2.39.tar.gz
#cd glibc-2.39
#mkdir build
#cd build
#../configure --prefix=${LOCAL_INSTALL_DIR}/glibc-2.34
#make -j32
#make install

# tree-sitter
# build dependencies
wget https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/l/llvm-libs-17.0.6-3.module%2Bel8.10.0%2B1869%2B0b51ffa4.x86_64.rpm
wget https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/l/llvm-devel-17.0.6-3.module%2Bel8.10.0%2B1869%2B0b51ffa4.x86_64.rpm
wget https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/c/clang-libs-17.0.6-1.module%2Bel8.10.0%2B1869%2B0b51ffa4.x86_64.rpm
rpm2cpio llvm-libs-17.0.6-3.module+el8.10.0+1869+0b51ffa4.x86_64.rpm | cpio -idmv
rpm2cpio llvm-devel-17.0.6-3.module+el8.10.0+1869+0b51ffa4.x86_64.rpm | cpio -idmv
rpm2cpio clang-libs-17.0.6-1.module+el8.10.0+1869+0b51ffa4.x86_64.rpm | cpio -idmv
wget https://dl.rockylinux.org/pub/rocky/8/AppStream/x86_64/os/Packages/c/clang-17.0.6-1.module%2Bel8.10.0%2B1869%2B0b51ffa4.x86_64.rpm
rpm2cpio clang-17.0.6-1.module+el8.10.0+1869+0b51ffa4.x86_64.rpm | cpio -idmv
wget https://dl.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/Packages/g/glibc-headers-2.28-251.el8_10.25.x86_64.rpm
rpm2cpio glibc-headers-2.28-251.el8_10.25.x86_64.rpm | cpio -idmv
wget https://dl.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/Packages/g/glibc-devel-2.28-251.el8_10.25.x86_64.rpm
rpm2cpio glibc-devel-2.28-251.el8_10.25.x86_64.rpm | cpio -idmv
# rust
curl https://sh.rustup.rs -sSf | sh
# tree-sitter-cli
git clone https://github.com/tree-sitter/tree-sitter.git
cd tree-sitter

cargo install tree-sitter-cli

# copilot
curl -fsSL https://gh.io/copilot-install | bash
