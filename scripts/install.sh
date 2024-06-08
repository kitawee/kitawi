#!/bin/bash

assetName="view" # Replace with the correct artifact name from your GitHub Actions workflow

# Construct API URL
apiURL="https://api.github.com/repos/bryanbill/view/releases/latest"

# Fetch release information
releaseInfo=$(curl -s "$apiURL")

# Check for errors fetching release information
if [[ $? -ne 0 ]]; then
    echo "Error fetching release information. Please check your repository details and try again."
    exit 1
fi

# Extract download URL for the specified asset
downloadURL=$(echo "$releaseInfo" | grep -Eo "\"browser_download_url\":.*\"$assetName\"" | cut -d '"' -f 4)

# Check for errors extracting download URL
if [[ -z "$downloadURL" ]]; then
    echo "Error finding download URL for the specified asset. Please check the asset name and try again."
    exit 1
fi

# Download and save executable
downloadPath="$HOME/your-app"
mkdir -p "$downloadPath"
exePath="$downloadPath/$assetName"  # Use the actual asset name in the file path
curl -L "$downloadURL" -o "$exePath"
chmod +x "$exePath"

# Add to PATH environment variable
echo "export PATH=\$PATH:$downloadPath" >> ~/.bashrc || echo "export PATH=\$PATH:$downloadPath" >> ~/.zshrc  # Add to both bash and zsh profiles if necessary
source ~/.bashrc || source ~/.zshrc

echo "Installation successful! You can now run '$assetName' from anywhere."  # Use the actual asset name in the message
