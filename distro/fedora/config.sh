echo "Installing Nix..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm;

echo "Updating Nix Container Ownership..."
sudo chown -R $(whoami):$(whoami) /nix/;
sudo chmod +x -R /nix/var/nix/profiles/default/etc/profile.d/

echo "Sourcing Nix..."
source ~/.bashrc;

echo "Installing Home Manager..."
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager;
sudo nix-channel --update;

nix-shell '<home-manager>' -A install;

