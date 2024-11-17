# clone into .local/dotfiles
mkdir -p ~/.local
cd ~/.local
[ -d dotfiles ] || git clone https://github.com/helium777/dotfiles.git
cd dotfiles

# update repo
git pull

# install nessessary packages
bash install.sh

# source init.zsh in the end of .zshrc
perl -i -ne 'print unless /source ~\/.local\/dotfiles\/zsh\/init.zsh/' ~/.zshrc
echo -e "\nsource ~/.local/dotfiles/zsh/init.zsh" >> ~/.zshrc
