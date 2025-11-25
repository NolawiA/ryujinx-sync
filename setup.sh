#!/bin/bash

set -e

GIT_REPO_SAVE="/c/Program Files/Ryujinx/ryujinx-sync/save"
RYUJINX_SAVE="$HOME/AppData/Roaming/Ryujinx/bis"

error() {
    printf "\n\033[0;31mERROR:\033[0m\n $1\n"
}

# Download rsync
curl -L -o rsync.pkg.tar.zst "https://repo.msys2.org/msys/x86_64/rsync-3.2.7-2-x86_64.pkg.tar.zst"

# Download required dependencies
curl -L -o libxxhash.pkg.tar.zst "https://repo.msys2.org/msys/x86_64/libxxhash-0.8.2-1-x86_64.pkg.tar.zst"
curl -L -o libzstd.pkg.tar.zst "https://repo.msys2.org/msys/x86_64/libzstd-1.5.6-1-x86_64.pkg.tar.zst"

# Extract all packages
/c/Windows/System32/tar.exe -xf rsync.pkg.tar.zst
/c/Windows/System32/tar.exe -xf libxxhash.pkg.tar.zst
/c/Windows/System32/tar.exe -xf libzstd.pkg.tar.zst

cp usr/bin/rsync.exe "/c/Program Files/Git/usr/bin/" || error "Run git bash as Administrator and run setup.sh again or manually copy usr/bin/rsync.exe into C:/Program Files/Git/usr/bin/"
cp usr/bin/msys-*.dll "/c/Program Files/Git/usr/bin/" || error "Run git bash as Administrator and run setup.sh again or manually copy usr/bin/rsync.exe into C:/Program Files/Git/usr/bin/"

rm -rf usr rsync.pkg.tar.zst libxxhash.pkg.tar.zst libzstd.pkg.tar.zst
rm .BUILDINFO .MTREE .PKGINFO

case "$1" in
    --primary)
        # init first save
        cp -r "$RYUJINX_SAVE" "$GIT_REPO_SAVE"

        git lfs install || error "Download Git Large File Storage: <https://docs.github.com/en/repositories/working-with-files/managing-large-files/installing-git-large-file-storage>"
        git lfs migrate import --include="save/**" --everything

        git add .
        git commit -m "init: first save"
        git push origin main -f
        ;;
    --non-primary)
        # copy existing save
        cp -r "$GIT_REPO_SAVE/bis/system" "$RYUJINX_SAVE"
        cp -r "$GIT_REPO_SAVE/bis/user" "$RYUJINX_SAVE"

        git lfs install || error "Download Git Large File Storage: <https://docs.github.com/en/repositories/working-with-files/managing-large-files/installing-git-large-file-storage>"
        git lfs migrate import --include="save/**" --everything
        ;;
    -h|--help)
        echo "Usage: $0 --primary for first device | $0 --non-primary for secondary or after device"
        ;;
    *)
        echo "Error: Invalid option. Use --primary, --non-primary, or --help"
        ;;
esac
