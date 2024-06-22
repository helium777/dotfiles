# clone into .local/dotfiles
cd ~/.local
[ -d dotfiles ] || git clone https://github.com/helium777/dotfiles.git

# install nessessary packages
cd dotfiles
bash install.sh

# source init.zsh in .zshrc
if ! grep -qxF "source ~/.local/dotfiles/zsh/init.zsh" ~/.zshrc; then
    echo -e "\nsource ~/.local/dotfiles/zsh/init.zsh" >> ~/.zshrc
fi
