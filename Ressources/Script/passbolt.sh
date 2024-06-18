#!/bin/bash

# Step 1. Download our dependencies installation script
echo "Downloading dependencies installation script..."
curl -LO https://download.passbolt.com/ce/installer/passbolt-repo-setup.ce.sh

# Step 2. Download our SHA512SUM for the installation script
echo "Downloading SHA512SUM for the installation script..."
curl -LO https://github.com/passbolt/passbolt-dep-scripts/releases/latest/download/passbolt-ce-SHA512SUM.txt

# Step 3. Ensure that the script is valid and execute it
echo "Verifying the script..."
sha512sum -c passbolt-ce-SHA512SUM.txt && sudo bash ./passbolt-repo-setup.ce.sh || (echo "Bad checksum. Aborting" && rm -f passbolt-repo-setup.ce.sh)
