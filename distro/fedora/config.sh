echo "Installing Nix..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

echo "Updating Nix Container Ownership..."
sudo chown -R $(whoami):$(whoami) /nix
sudo chmod +x -R /nix/var/nix/profiles/default/etc/profile.d/

echo "Sourcing Nix..."
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

echo "Removing Previous Install Of Home-Manager..."
rm -f /home/$(whoami)/.local/state/nix/profiles/home-manager*
rm -f /home/$(whoami)/.local/state/home-manager/gcroots/current-home


echo "Installing Home Manager..."
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install

exit 0
