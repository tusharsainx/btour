#!/bin/bash

# Create directories if they don't exist
mkdir -p assets/fonts
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/animations

# Base URLs
POPPINS_URL="https://github.com/google/fonts/raw/main/ofl/poppins"
PLAYFAIR_URL="https://github.com/google/fonts/raw/main/ofl/playfairdisplay"

# Download Poppins
echo "Downloading Poppins fonts..."
curl -L -o assets/fonts/Poppins-Light.ttf "$POPPINS_URL/Poppins-Light.ttf"
curl -L -o assets/fonts/Poppins-Regular.ttf "$POPPINS_URL/Poppins-Regular.ttf"
curl -L -o assets/fonts/Poppins-Medium.ttf "$POPPINS_URL/Poppins-Medium.ttf"
curl -L -o assets/fonts/Poppins-SemiBold.ttf "$POPPINS_URL/Poppins-SemiBold.ttf"
curl -L -o assets/fonts/Poppins-Bold.ttf "$POPPINS_URL/Poppins-Bold.ttf"

# Download Playfair Display
echo "Downloading Playfair Display fonts..."
curl -L -o assets/fonts/PlayfairDisplay-Regular.ttf "$PLAYFAIR_URL/PlayfairDisplay-Regular.ttf"
curl -L -o assets/fonts/PlayfairDisplay-Bold.ttf "$PLAYFAIR_URL/PlayfairDisplay-Bold.ttf"

# Create a placeholder image just in case
touch assets/images/placeholder.png
touch assets/icons/app_icon.png
