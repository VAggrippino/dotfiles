#!/bin/bash

function show_help() {
    local bold=$(tput bold)
    local underline=$(tput smul)
    local plain=$(tput sgr0)
    echo "\
Usage:
    $(basename $0) -p ${bold}${underline}<parent repository>${plain} -s ${bold}${underline}<submodule path>${plain}

	The submodule path must be relative to the parent repository.
"
}

echo "Argument Count: $#"

if [[ $# -ne 4 ]]; then
    show_help
    exit
else
    echo "$# equals 4"
fi

while getopts "p:s:" flag; do
    case $flag in
    p)
        parent_repo=$OPTARG
        ;;
    s)
        submodule_path=$OPTARG
        ;;
    *)
        show_help
        exit
        ;;
    esac
done

echo "Parent Repo: $parent_repo"
echo "Submodule Path $submodule_path"

#OHMYZSH_UPDATE_FILE="$HOME/.ohmyzsh-updated.txt"
#DOTFILES="$HOME/dotfiles"
#OHMYZSH_SUBMODULE="zsh/.oh-my-zsh"
#
## Update the oh-my-zsh submodule
#function submodule_update() {
#  git -C "$DOTFILES" submodule update "$OHMYZSH_SUBMODULE"
#  return
#}
#
## Generate a human-readable update message for the content of the update file
#function ohmyzsh_update_message() {
#  echo "The OhMyZsh submodule was last updated on $(date +%F)"
#}
#
## If the update file doesn't exist, update the submodule and update file
#if [[ ! -f "$OHMYZSH_UPDATE_FILE" ]]; then
#  echo "$OHMYZSH_SUBMODULE file not found. Updating OhMyZsh submodule..."
#  submodule_update && ohmyzsh_update_message > $OHMYZSH_UPDATE_FILE
#
## Otherwise update if the specified number of days has passed
#else
#  function {
#    local UPDATE_TIMESTAMP=$(stat --printf %Y $OHMYZSH_UPDATE_FILE)
#    local CURRENT_TIMESTAMP=$(date +%s)
#    #
#    # Change DAYS to update more or less frequently
#    local DAYS=14
#    local SECONDS=$((DAYS * 24 * 60 * 60))
#
#    if [[ $((CURRENT_TIMESTAMP - SECONDS)) -ge $UPDATE_TIMESTAMP ]]; then
#      echo "The OhMyZsh submodule hasn't been updated in at least $DAYS days. Running update now..."
#      submodule_update && ohmyzsh_update_message > $OHMYZSH_UPDATE_FILE
#    fi
#  }
#fi
