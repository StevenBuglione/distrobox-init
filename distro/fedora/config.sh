#!/bin/bash

# Variables
USER="sbuglione"

su $USER

echo "Checking if already configured"
if [ -f "$HOME/.boot/active" ]; then
    echo "Already configured"
    exit 0
else
    echo "Installing Nix..."
    su - "$USER" -c 'curl --proto "=https" --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm'

    echo "Updating Nix Container Ownership..."
    sudo chown -R "$USER":"$USER" /nix
    sudo chmod +x -R /nix/var/nix/profiles/default/etc/profile.d/

    echo "Sourcing Nix..."
    su - "$USER" -c 'source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'

    echo "Removing Previous Install of Home Manager..."
    su - "$USER" -c '
        rm -f $HOME/.local/state/nix/profiles/home-manager*
        rm -f $HOME/.local/state/home-manager/gcroots/current-home
        rm -rf $HOME/.config/home-manager/
    '

    echo "Installing Home Manager..."
    su - "$USER" -c '
        nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
        nix-channel --update
        nix-shell "<home-manager>" -A install
    '

    echo "Removing Previous Install of Oh-My-Zsh..."
    sudo rm -rf "$HOME/.oh-my-zsh/"

    echo "Cloning Home Manager Repository..."
    sudo rm -rf "$HOME/.config/home-manager/"
    su - "$USER" -c '
        nix-shell -p git --run "
            git clone https://github.com/StevenBuglione/home-manager.git $HOME/.config/home-manager
            cd $HOME/.config/home-manager
            git remote set-url origin git@github.com:StevenBuglione/home-manager.git
        "
    '

    echo "Installing Oh-My-Zsh..."
    su - "$USER" -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

    echo "Running Home Manager..."
    su - "$USER" -c 'home-manager switch'

    echo "Setting Zsh as Default Shell..."
    su - "$USER" -c 'chsh -s "$(which zsh)"'

    echo "Cleaning up .zshrc..."
    sudo rm -f "$HOME/.zshrc"
    su - "$USER" -c 'home-manager switch'

    echo "Setting Boot Flag..."
    su - "$USER" -c '
        mkdir -p $HOME/.boot/
        touch $HOME/.boot/active
    '
fi

exit 0



