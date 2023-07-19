# Vince's dotfiles
This repository contains configuration settings for some apps or tools that would normally be managed by way of a live Git repository that is regularly updated by the tool. I've used Git submodules for managing these configurations.

Most notable of these is OhMyZsh. In my OhMyZsh configuration, I've disabled the tool's automated updates in favor of my own code which is significantly less complex, but may be slightly more robust.

This implementation based on testing with a newly installed Ubuntu 22.04.2 system.

## Warning
This repository contains _my_ preferred configuration. There may be some good ideas implemented here. There are almost certainly some bad ideas implemented here.

Use of anything found here is at your own risk. In spite of what some YouTubers may say, it's a really bad idea to just copy another person's configuration wholesale.

It's a really good idea to look through the settings and configuration files found here and _decide_ if they will work well for you.


## Abbreviated Commands for Dependencies and Recommendations (aka TL;DR)

1. Packages from Ubuntu repositories:

    ```
    sudo apt update && sudo apt -y upgrade && sudo apt -y install stow git tmux bat exa libfuse2 python-is-python3 zlib1g-dev libbz2-dev libreadline-dev libssl-dev vim-gtk zsh
    ```

2. Change default shell:

    ```
    chsh -s $(which zsh)
    ```

3. Clone the dotfiles repository and all submodules

    ```
    git clone --recurse-submodules --shallow-submodules --remote-submodules git@github.com:VAggrippino/dotfiles.git ~/dotfiles
    ```

    - This command will pull the latest changes from the submodule projects. When it's done, add, commit, and push the changes. **Install the git configuration with stow first!**

4. Log out and back in in order for the change made by `chsh` to take effect.

-----

## Initial Steps
- Install Git, to clone the repository, and [Stow](https://www.gnu.org/software/stow/), to _install_ the configurations:

    ```
    sudo apt -y install git stow
    ```

    - It's entirely possible to use this without Stow. All Stow does is make symbolic links

## Individual configuration dependencies
### bash
- Bash has no dependencies, but a new or existing system will likely already have `.bashrc` and `.profile` files and stow will refuse to replace them.

### bin
- No dependencies. These are just a few helper scripts to make it easier to run other programs.
- This folder is also where I install AppImage files (e.g. Neovim), but I exclude them with a `.gitignore` file because they're pretty big and it's better not to manage them in this repository.

### fonts
- No dependencies. After installing them, you'll need to close and re-open any terminal or other app you expect to use them.

### git
- Depends on git, but probably installed git in order to get the files anyway.

### neovim
- Depends on Neovim. I prefer the AppImage for the nightly build, installed like this:
    ```
    curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage $HOME/bin/nvim.appimage
    ```

### nvm https://github.com/nvm-sh/nvm
- No dependencies... not even NodeJS 😁

### omzcustom
- Codependent with OhMyZsh (installed via the zsh stow directory)

### pyenv https://github.com/pyenv/pyenv
- Building and installing Python versions with pyenv requires zlib, bzip2, readline, SSL, and SQLite (technically optional). These can be easily installed via the Ubuntu package repository:

    ```
    sudo apt -y install zlib1g-dev libbz2-dev libreadline-dev libssl-dev libsqlite3
    ```
- Not a dependency, but convenient... By default, Ubuntu doesn't have a `/usr/bin/python`, just `/usr/bin/python3` which pyenv doesn't see. The `python-is-python3` package from the Ubuntu repository will make a symbolic link from `/usr/bin/python` → `/usr/bin/python3` that can be installed easily:

    ```
    sudo apt -y install python-is-python3
    ```

### tmux
- No dependencies
- To configure a terminal app to automatically start tmux with an existing or new session, the command is `tmux new-session -A`.


## Other Recommendations
- `exa` - enhanced alternative to `ls`
    ```
    sudo apt -y install exa
    ```
- `bat` - enhanced alternative to `cat`
    ```
    sudo apt -y install bat
    ```

    - Ubuntu installs this package with the command `batcat`, doe to a conflict. One of the scripts in the `bin` stow is a `bat` command that points to `/usr/bin/batcat`
- Vim & GVim
    ```
    sudo apt -y install vim-gtk
    ```

    - This is a core necessity even if you prefer Neovim as your primary editor
    - I use this as a pager for `man`
- Neovim - enhanced alternative to Vim
    - The package in the Ubuntu repository is old. I prefer to use the nightly AppImage build:
    ```
    curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage $HOME/bin/nvim.appimage
    ```
- AppImageUpdate - semi-automated update tool for AppImages.
https://github.com/AppImageCommunity/AppImageUpdate/releases
    - This is a neat tool, but I ran into rate limit problems during testing. In related GitHub issues, I noticed that the development team had a preference for web scraping over properly using GitHub's API. This was from a 5+ year-old thread, so I won't be depending too much on this tool
