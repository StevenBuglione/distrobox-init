echo "Installing Nix..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm;

echo "Updating Nix Container Ownership..."
sudo chown -R $(whoami):$(whoami) /nix/;

echo "Installing Home Manager..."
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager;
sudo nix-channel --update;

source ~/.bashrc;
nix-shell '<home-manager>' -A install;

