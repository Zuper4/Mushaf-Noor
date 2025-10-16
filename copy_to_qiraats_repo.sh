#!/bin/bash

# Script to copy qiraat images to the mushaf-qiraats repository
# Usage: ./copy_to_qiraats_repo.sh /path/to/mushaf-qiraats

if [ $# -eq 0 ]; then
    echo "Usage: $0 /path/to/mushaf-qiraats-repo"
    echo "Example: $0 ../mushaf-qiraats"
    exit 1
fi

QIRAATS_REPO_PATH="$1"

if [ ! -d "$QIRAATS_REPO_PATH" ]; then
    echo "Error: Directory $QIRAATS_REPO_PATH does not exist"
    echo "Please clone the mushaf-qiraats repository first:"
    echo "git clone https://github.com/Zuper4/mushaf-qiraats.git"
    exit 1
fi

echo "🕌 Copying qiraat images to mushaf-qiraats repository..."

# Re-download the qiraat folders from your GitHub repo
echo "📥 Downloading qiraat images from your Mushaf-Noor repository..."
git clone --depth 1 --no-checkout https://github.com/Zuper4/Mushaf-Noor.git temp_qiraats
cd temp_qiraats
git checkout HEAD -- assets/images/qiraats/
cd ..

# Copy all qiraat folders except asim_hafs
echo "📁 Copying qiraat folders..."
for folder in temp_qiraats/assets/images/qiraats/*; do
    folder_name=$(basename "$folder")
    if [ "$folder_name" != "asim_hafs" ] && [ "$folder_name" != ".DS_Store" ]; then
        echo "  Copying $folder_name..."
        cp -r "$folder" "$QIRAATS_REPO_PATH/"
    fi
done

# Clean up
rm -rf temp_qiraats

echo "✅ Done! All qiraat folders copied to $QIRAATS_REPO_PATH"
echo ""
echo "Next steps:"
echo "1. cd $QIRAATS_REPO_PATH"
echo "2. git add ."
echo "3. git commit -m 'Add all qiraat images for Mushaf Noor app'"
echo "4. git push origin main"
echo "5. Enable GitHub Pages in repository settings"
echo ""
echo "🌐 Your qiraats will be available at:"
echo "   https://zuper4.github.io/mushaf-qiraats/"