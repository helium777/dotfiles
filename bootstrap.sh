# clone into .local/dotfiles
mkdir -p ~/.local
cd ~/.local
[ -d dotfiles ] || git clone https://github.com/helium777/dotfiles.git
cd dotfiles

# update repo
git pull

# install nessessary packages
bash install.sh

# source init.zsh in .zshrc
if ! grep -qxF "source ~/.local/dotfiles/zsh/init.zsh" ~/.zshrc; then
    echo -e "\nsource ~/.local/dotfiles/zsh/init.zsh" >> ~/.zshrc
fi
