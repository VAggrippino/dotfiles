# Replacement for auto-update to accommodate the dotfiles submodule
dotfiles="$HOME/dotfiles"
ohmyzsh_update_file="$dotfiles/.ohmyzsh-updated.txt"
ohmyzsh_submodule="zsh/.oh-my-zsh"

function update_ohmyzsh_submodule() {
    printf "Updating OhMyZsh submodule in $dotfiles/$ohmyzsh_submodule...\n\n"
    # Without --remote, git would only fetch the branch/commit that was latest
    # when the submodule was last added to the repo
    git -C "$dotfiles" submodule update --remote "$ohmyzsh_submodule"

    local update_status=$?

    # Only update the dotfiles repo if the submodule update was successful
    if [[ $update_status -eq 0 ]]; then
        # If the OhMyZsh project has been updated, this will link its latest
        # commit to the dotfiles repo
        # If there were no updates, there will be a "nothing to commit"
        # message, but nothing will be changed
        git -C "$dotfiles" add "$ohmyzsh_submodule"
        git -C "$dotfiles" commit -m "Automatically updated OhMyZsh submodule"
        git -C "$dotfiles" push
    fi

    return $update_status
}

# Generate a human-readable update message for the content of the update file
function ohmyzsh_update_message() {
    echo "Time of OhMyZsh submodule update: $(date --iso-8601='seconds')"
}

perform_ohmyzsh_update=""
# If the update file doesn't exist or it hasn't been updated in the specified
# number of days, update the OhMyZsh submodule and the update file
if [[ ! -f "$ohmyzsh_update_file" ]]; then
    echo "$ohmyzsh_submodule file not found."
    perform_ohmyzsh_update="yes"

else
    # Anonymous function allows locally scoped variables
    function {
        local update_timestamp=$(stat --printf %Y $ohmyzsh_update_file)
        local current_timestamp=$(date +%s)

        # Change DAYS to update more or less frequently
        local days=14
        local seconds=$((days * 24 * 60 * 60))

        # If more than ${days} have passed since the last update, update the
        # submodule and update tracking file
        if [[ $((current_timestamp - seconds)) -ge $update_timestamp ]]; then
            printf "The OhMyZsh submodule hasn't been updated in at least $days days.\n"
            perform_ohmyzsh_update="yes"
        fi
    }
fi

if [[ "$perform_ohmyzsh_update" == "yes" ]]; then
    if update_ohmyzsh_submodule; then
        ohmyzsh_update_message |tee $ohmyzsh_update_file
    fi
fi

## ↑ Placed before the Powerlevel10k Instant prompt to avoid error from Powerlevel10k

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LC_ALL=en_US.UTF-8

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  vi-mode
  nvm
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Things to do only on WSL
iswsl=$(uname -r | grep -i microsoft)
if [ $iswsl ]
then
  export BROWSER=wslview
  export DISPLAY=$(cat /etc/resolv.conf | grep name | cut -d' ' -f2):0.0
fi

export EDITOR=nvim

export PATH="$PATH:$HOME/.pyenv/bin"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/bin:$PATH"
export CDPATH="$CDPATH:$HOME/dev"

#export PAGER="/bin/sh -c \"col -b -x | nvim -R \
#    -c 'set ft=man mouse=a nonumber t_te=' \
#    -c 'colorscheme slate' \
#    -c 'highlight Normal ctermbg=NONE guibg=NONE' \
#    -c 'map q :q<CR>' \
#    -c 'map <SPACE> <C-D>' \
#    -c 'map b <C-U>' \
#    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""
#
## `!"` has special meaning in Zsh (man zshexpn)
#export MANPAGER="nvim --clean +Man!"

export MANPAGER="vim -c 'set nonu mouse=a' -c 'colors slate' -M +MANPAGER -"

# Fix for the bat command
export BAT_PAGER=less

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _match _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' glob 1
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' match-original both
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: %l matches, %p%s
zstyle ':completion:*' substitute 1
zstyle :compinstall filename '/home/vaggrippino/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
