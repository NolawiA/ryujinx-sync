#!/bin/bash

GIT_REPO_PATH="/c/Program Files/Ryujinx/ryujinx-sync"
GIT_REPO_SAVE="/c/Program Files/Ryujinx/ryujinx-sync/save"
RYUJINX_SAVE="$HOME/AppData/Roaming/Ryujinx/bis"
RYUJINX_EXE="/c/Program Files/Ryujinx/publish/Ryujinx.exe"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "[Ryujinx Sync]${GREEN}[INFO]${NC} $1\n"
}

warn() {
    echo -e "[Ryujinx Sync]${YELLOW}[WARN]${NC} $1\n"
}

error() {
    echo -e "[Ryujinx Sync]${RED}[ERROR]${NC} $1\n"
}

pull_saves() {
    log "Pulling latest saves from GitHub..."

    if [ -d "$GIT_REPO_PATH" ]; then
        cd "$GIT_REPO_PATH"

        git remote update -p
        LOCAL=$(git rev-parse HEAD)
        REMOTE=$(git rev-parse origin/main)

        if [ "$LOCAL" != "$REMOTE" ]; then
            git reset --hard origin/main
            rsync -aP "$GIT_REPO_SAVE/bis/system" "$RYUJINX_SAVE"
            rsync -aP "$GIT_REPO_SAVE/bis/user" "$RYUJINX_SAVE"
            log "Saves synced from GitHub"
        else
            log "Already up to date"
        fi
    else
        error "Git repository not found at $GIT_REPO_PATH"
    fi
}

push_saves() {
    log "Pushing saves to GitHub..."

    if [ -d "$GIT_REPO_PATH" ]; then
        cd "$GIT_REPO_PATH"

        rsync -aP "$RYUJINX_SAVE" "$GIT_REPO_SAVE"
        git add save/

        if [ -n "$(git status --porcelain)" ]; then
            git commit -m "save: $(date '+%Y-%m-%d %H:%M:%S')"

            if git push origin main; then
                log "Saves backed up to GitHub"
            else
                warn "Could not push to GitHub (may be offline)"
            fi
        else
            log "No save changes detected"
        fi
    else
        error "Git repository not found at $GIT_REPO_PATH"
    fi
}

start_ryujinx() {
    if [[ "$1" == "--game" ]]; then
        GAME_PATH="$2"
        log "Launching directly into $GAME_PATH"
        "$RYUJINX_EXE" "$GAME_PATH" & PID=$!
    else
        log "Starting Ryujinx launcher"
        "$RYUJINX_EXE" & PID=$!
    fi

    wait -f $PID 
}

log "--- Ryujinx Save Sync Started ---"
pull_saves

log "--- Ryujinx Started ---"
start_ryujinx "$@"
log "--- Ryujinx Closed ---"

push_saves
log "--- Save Sync Complete ---"
sleep 5
