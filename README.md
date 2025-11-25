# Ryujinx Save Sync

Automatically sync and backup save data for Ryujinx games across different devices

*WARNING: GitHub with git-lfs has 10GiB bandwidth and storage limit per month. See [docs](https://docs.github.com/en/billing/concepts/product-billing/git-lfs#free-use-of-git-lfs)*


## What This Does

This script automatically syncs your Ryujinx game save data to your GitHub repository every time you play by:

1. **Launching the game through Steam with modified target**: Pulls the latest save data from GitHub and then launches Ryujinx 
2. **After closing Ryujinx**: Automatically commits and pushes your updated saves to GitHub
3. **Profit**: from your laziness 😹


## Use Cases

- **Multi-computer setup**: Play your games on different computers and keep saves in sync (Mine is main pc and tv rig)
- **Version history**: Dated Git commits for every save, so you can recover from mistakes or corrupted saves


## Prerequisites

- **Windows** with **Git Bash** installed
- **Ryujinx** emulator installed and registered on **Steam** (Optional)
- **Git** configured with your **GitHub** credentials and [**Git Large File Storage**](https://docs.github.com/en/repositories/working-with-files/managing-large-files/installing-git-large-file-storage)


## Installation

#### 1. Clone this repo and create your private GitHub repo to connect to

```bash
# Only needs to be done once
git clone https://github.com/NolawiA/ryujinx-sync.git
cd ryujinx-sync
git remote remove origin
git remote add origin <your-private-repo-url> # MAKE SURE YOUR REPO IS PRIVATE
```

#### 2. Allow the scripts to be executable

```bash
# ryujinx-sync.sh depends on rsync and doesn't come with Git Bash for Windows by default
chmod +x setup.sh
chmod +x ryujinx-sync.sh
```

#### 3. Configure the script

Update these paths if needed:

```bash
# ryujinx-sync.sh
GIT_REPO_PATH="/c/Program Files/Ryujinx/ryujinx-sync"
GIT_REPO_SAVE="/c/Program Files/Ryujinx/ryujinx-sync/save"
RYUJINX_SAVE="$HOME/AppData/Roaming/Ryujinx/bis"
RYUJINX_EXE="/c/Program Files/Ryujinx/publish/Ryujinx.exe"

# setup.sh 
RYUJINX_SAVE="$HOME/AppData/Roaming/Ryujinx/bis"
GIT_REPO_SAVE="/c/Program Files/Ryujinx/ryujinx-sync/save"
```

> WARNING: paths need to match across all devices

#### 4. Run setup script with Terminal/Git Bash as Administrator 

```bash
# Might take a while for the first primary device push
# --primary is for the first/original device, --non-primary for secondary+ device(s)
./setup.sh <--primary|--non-primary>
```

Setup is complete! You can choose from any method below or just run `./ryujinx-sync.sh` or `./ryujinx-sync.sh --game <GAME_PATH>` to launch directly into a game (good for steam method)

### Launch Methods

#### Steam (for good controller support)

1. In Steam Library: Games -> Add a Game (bottom left) -> **Add a Non-Steam Game...**
2. Click **Browse** and navigate to your `Ryujnix.exe` path
3. After adding, right-click -> **Properties**
4. Change **Target** to:
```
# Prefix with "C:\Windows\System32\cmd.exe" \c start "OPTIONAL_GAME_TITLE" ... if you want to close the game through Steam and not closing Ryujinx window
# example: "C:\Program Files\Git\bin\bash.exe" -c '/c/Program\ Files/Ryujinx/ryujinx-sync/ryujinx-sync.sh --game /c/Program\ Files/Ryujinx/games/Paper\ Mario.xci'
"C:\Program Files\Git\bin\bash.exe" -c '<YOUR_RYUJINX_SYNC_PATH>/ryujinx-sync.sh'
```
5. (Optional) Use `ryujinx_logo.png` and `ryujinx_banner.png` from `images/` to decorate by right clicking the banner after exiting properties
> Note: .png files work on all steam image properties

#### Windows Shortcut (fastest and if you don't need controller support)

1. Create a new shortcut with the target as the path to your shell of choice by right clicking anywhere on your screen saver and hitting new -> shortcut
2. Open up the properties of the shortcut and fix the target to call the scriptin your ryujinx-sync folder and set the start in as the path to directory of ryujinx-sync
> my target path: "C:\Program Files\Git\bin\bash.exe" -i -l -c './ryujinx-sync.sh'"
>
> my start in path: C:\Program Files\Ryujinx\ryujinx-sync
3. If you want an icon for your shortcut, hit the change icon button in the properties and use the ryujinx.ico in `images/`
4. Exit the properties and double click the shortcut to start, then from the running shortcut in the taskbar, right click and hit pin to taskbar


## Restore Old Saves

```bash
cd /c/Program Files/Ryujinx/ryujinx-sync

# List commits
git log --oneline

# Restore to a specific date
git checkout <commit-hash>

# Return to latest to undo
git checkout main
```


## License

This project is licensed under the Creative Commons Attribution-NonCommercial 4.0 International Public License - see the LICENSE.txt.

## Credits

<https://ryujinx.app/>

<https://git.ryujinx.app/ryubing/ryujinx>
