echo "Removing git"
sudo dnf remove -y git

echo "Installing Nix..."
su sbuglione
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

echo "Updating Nix Container Ownership..."
sudo chown -R sbuglione:sbuglione /nix
sudo chmod +x -R /nix/var/nix/profiles/default/etc/profile.d/

echo "Sourcing Nix..."
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

echo "Removing Previous Install Of Home-Manager..."
rm -f /home/sbuglione/.local/state/nix/profiles/home-manager*
rm -f /home/sbuglione/.local/state/home-manager/gcroots/current-home
rm -r /home/sbuglione/.config/home-manager/

echo "Installing Home Manager..."
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install

echo "Removing Previous Install Of Home-Manager Repo..."
rm -r /home/.config/home-manager/
nix-shell -p git --run "git clone https://github.com/StevenBuglione/home-manager.git /home/.config/home-manager"

echo "Running Home-Manager..."
home-manager switch

exit 0
