echo "Installing Nix..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

echo "Updating Nix Container Ownership..."
sudo chown -R $(whoami):$(whoami) /nix
sudo chmod +x -R /nix/var/nix/profiles/default/etc/profile.d/

echo "Sourcing Nix..."
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Check and remove the files if they exist
if [ -e /home/$(whoami)/.local/state/nix/profiles/home-manager* ]; then
  rm -fv /home/$(whoami)/.local/state/nix/profiles/home-manager*
fi

if [ -e /home/$(whoami)/.local/state/home-manager/gcroots/current-home ]; then
  rm -fv /home/$(whoami)/.local/state/home-manager/gcroots/current-home
fi

echo "Installing Home Manager..."
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install

