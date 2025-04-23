set -e

# clone into ~/.local/dotfiles
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
perl -i -pe 'print "source ~/.local/dotfiles/zsh/init.zsh\n" if $. == 1' ~/.zshrc
