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
sudo rm -r /home/sbuglione/.oh-my-zsh/

echo "Removing Previous Install Of Home-Manager Repo..."
sudo rm -r /home/sbuglione/.config/home-manager/
nix-shell -p git --run "git clone https://github.com/StevenBuglione/home-manager.git /home/sbuglione/.config/home-manager && cd /home/sbuglione/.config/home-manager && git remote set-url origin git@github.com:StevenBuglione/home-manager.git"

echo "Installing Oh-My-Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Running Home-Manager..."
home-manager switch

echo "Setting Zsh As Default Shell..."
chsh -s $(which zsh)

sudo rm /home/sbuglione/.zshrc
home-manager switch

exit 0
