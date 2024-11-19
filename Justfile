# A Justfile For Automating Tasks Related To Generating, Deploying and Testing New Distrobox Images

set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Helper task for green messages
echo-green message:
    @echo -e "\033[1;32m{{message}}\033[0m"


# Helper task for red messages
echo-red message:
    @echo -e "\033[1;31m{{message}}\033[0m"  # Suppresses this echo from being logged

# Build Fedora
build-fedora:
    @just echo-green "Calling Fedora Build..."
    @just -f ./distro/fedora/Justfile build

# Test Fedora Build
test-build-fedora:
    @just echo-green "Calling Fedora Test Build..."
    @just -f ./distro/fedora/Justfile test-build





# Example task with red output
task-with-error:
    @just echo-red "Something went wrong!"