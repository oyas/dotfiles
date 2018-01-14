#!/bin/bash


how_to_setup(){
	echo "1. To be able to use add-apt-repository you may need to install software-properties-common:"
	echo "  $ sudo apt-get install software-properties-common"
	echo ""
	echo "2. Install vim 8.0"
	echo "  $ sudo add-apt-repository ppa:jonathonf/vim"
	echo "  $ sudo apt update"
	echo "  $ sudo apt install vim"
	echo ""
	echo "3. Install neovim package in python. It is required to use neovim plugin."
	echo "  $ pip3 install neovim"
	echo ""
	echo "4. Install ctags"
	echo "  4.1 Easy to install ctags, run this:"
	echo "    $ sudo apt install exuberant-ctags"
	echo ""
	echo "  4.2 If you want to use universal-ctags, run this:"
	echo "    $ sudo apt install autoconf automake libtool"
	echo "    $ mkdir -p ~/.local/src && cd ~/.local/src"
	echo "    $ git clone https://github.com/universal-ctags/ctags.git"
	echo "    $ cd ctags"
	echo "    $ ./autogen.sh"
	echo "    $ ./configure --prefix=${HOME}/.local"
	echo "    $ make && make install"
	echo "    Add ~/.local/bin to PATH"
	echo "    $ echo 'export PATH=\"${HOME}/.local/bin:\$PATH\"' >> ~/.bashrc"
	echo ""
	echo "5. Install flake8, mypy and jedi for editing python."
	echo "  $ pip3 install flake8 mypy jedi"
	echo ""
	echo "6. Rerun this script."
	echo ""
	echo "When you want to see this how_to_setup message, type setup_vim.sh -h"
}

if [[ $1 == "-h" ]]; then
	echo "Usage: $0 [-h]"
	echo "    -h  Show usage and how_to_setup"
	echo ""
	echo "how_to_setup:"
	how_to_setup
	exit
fi

# vim がインストールされていることの確認
if type "vim" > /dev/null 2>&1; then :
else
	echo "vim が存在しません。"
	how_to_setup
	exit
fi

# vim のバージョン確認
vim_version=`vim --version | head -n 1 | cut -d ' ' -f 5`
if [[ $vim_version =~ ^[0-7]\.([0-9]+) ]]; then
	echo "vim 8.0以上に更新してください。 現在のvimのバージョン: $vim_version"
	how_to_setup
	exit
	# if you want to uninstall:
	#   $ sudo apt remove vim
	#   $ sudo add-apt-repository --remove ppa:jonathonf/vim
fi

# deopleteのためにneovimパッケージがインストールされている必要がある
check=`python3 -c "import neovim" 2>&1`
if [[ -n $check ]]; then
	echo "neovim パッケージがインストールされていません。"
	echo "  $ pip3 install neovim"
	exit
fi

# このスクリプトのあるディレクトリ
basedir=`dirname $0`
basedir=`cd $basedir; pwd`

# .vimrc 作成
if [ -e ~/.vimrc ]; then
	echo "~/.vimrc がすでに存在します。"
	echo -n "上書きしますか？ [y/N] "
	read ANSWER
	case $ANSWER in
		"Y" | "y" | "yes" | "Yes" | "YES" )
			rm ~/.vimrc;;
		* )
			echo "cancelled"
			exit
			;;
	esac
fi
echo "ln -s ${basedir}/.vimrc ~/.vimrc"
ln -s ${basedir}/.vimrc ~/.vimrc

# .config/nvim/dein.toml 作成
mkdir -p ${HOME}/.config/nvim
if [ -e ${HOME}/.config/nvim/dein.toml ]; then
	echo "~/.config/nvim/dein.toml がすでに存在します。"
	echo -n "上書きしますか？ [y/N] "
	read ANSWER
	case $ANSWER in
		"Y" | "y" | "yes" | "Yes" | "YES" )
			rm ~/.config/nvim/dein.toml;;
		* )
			echo "cancelled"
			exit
			;;
	esac
fi
echo "ln -s ${basedir}/.config/nvim/dein.toml ${HOME}/.config/nvim/dein.toml"
ln -s ${basedir}/.config/nvim/dein.toml ${HOME}/.config/nvim/dein.toml

# .config/flake8 設定
if [ ! -e ${HOME}/.config/flake8 ]; then
	echo "ln -s ${basedir}/.config/flake8 ${HOME}/.config/flake8"
	ln -s ${basedir}/.config/flake8 ${HOME}/.config/flake8
fi

echo "finished!"
exit
