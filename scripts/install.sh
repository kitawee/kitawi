#!/bin/bash

# GitHub repository details
REPO="bryanbill/view"
API_URL="https://api.github.com/repos/$REPO/releases/latest"

# Determine platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux"
else
    echo "Unsupported platform: $OSTYPE"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Installing jq..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install jq
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update
        sudo apt-get install -y jq
    fi
fi

# Fetch the latest release info
echo "Fetching latest release info..."
RELEASE_INFO=$(curl -s $API_URL)

# Extract the version and download URL
VERSION=$(echo "$RELEASE_INFO" | jq -r '.tag_name')

DOWNLOAD_URL=https://github.com/bryanbill/view/releases/download/$VERSION/view-$PLATFORM

# # Download the latest binary
echo "Downloading view $VERSION for $PLATFORM..."
curl -L $DOWNLOAD_URL -o vw

# Make the binary executable
chmod +x vw

# Move the binary to /usr/local/bin
sudo mv vw /usr/local/bin/vw

# Confirm installation
echo "view installed successfully. Version: $VERSION"

# Add view to PATH using bashrc for linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Adding view to PATH..."
    echo "export PATH=\$PATH:/usr/local/bin" >> ~/.bashrc
    echo "Please restart your terminal or run 'source ~/.bashrc' to use the 'vw' command."
fi

# Add view to PATH using zshrc for macos
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Adding view to PATH..."
    echo "export PATH=\$PATH:/usr/local/bin" >> ~/.zshrc
    echo "Please restart your terminal or run 'source ~/.zshrc' to use the 'vw' command."
fi


echo "You can now use the 'vw' command."
