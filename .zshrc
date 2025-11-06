## Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
## Initialization code that may require console input (password prompts, [y/n]
## confirmations, etc.) must go above this block; everything else may go below.
#
## If you come from bash you might have to change your $PATH.
## export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
#
## Path to your Oh My Zsh installation.
#export ZSH="$HOME/.oh-my-zsh"
#
## Set name of the theme to load --- if set to "random", it will
## load a random theme each time Oh My Zsh is loaded, in which case,
## to know which specific one was loaded, run: echo $RANDOM_THEME
## See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
##ZSH_THEME="heapbytes-mac"
#ZSH_THEME="alanpeabody"
#
## Set list of themes to pick from when loading at random
## Setting this variable when ZSH_THEME=random will cause zsh to load
## a theme from this variable instead of looking in $ZSH/themes/
## If set to an empty array, this variable will have no effect.
## ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
#
## Uncomment the following line to use case-sensitive completion.
## CASE_SENSITIVE="true"
#
## Uncomment the following line to use hyphen-insensitive completion.
## Case-sensitive completion must be off. _ and - will be interchangeable.
## HYPHEN_INSENSITIVE="true"
#
## Uncomment one of the following lines to change the auto-update behavior
## zstyle ':omz:update' mode disabled  # disable automatic updates
## zstyle ':omz:update' mode auto      # update automatically without asking
## zstyle ':omz:update' mode reminder  # just remind me to update when it's time
#
## Uncomment the following line to change how often to auto-update (in days).
## zstyle ':omz:update' frequency 13
#
## Uncomment the following line if pasting URLs and other text is messed up.
## DISABLE_MAGIC_FUNCTIONS="true"
#
## Uncomment the following line to disable colors in ls.
## DISABLE_LS_COLORS="true"
#
## Uncomment the following line to disable auto-setting terminal title.
## DISABLE_AUTO_TITLE="true"
#
## Uncomment the following line to enable command auto-correction.
## ENABLE_CORRECTION="true"
#
## Uncomment the following line to display red dots whilst waiting for completion.
## You can also set it to another string to have that shown instead of the default red dots.
## e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
## Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
## COMPLETION_WAITING_DOTS="true"
#
## Uncomment the following line if you want to disable marking untracked files
## under VCS as dirty. This makes repository status check for large repositories
## much, much faster.
## DISABLE_UNTRACKED_FILES_DIRTY="true"
#
## Uncomment the following line if you want to change the command execution time
## stamp shown in the history command output.
## You can set one of the optional three formats:
## "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
## or set a custom format using the strftime function format specifications,
## see 'man strftime' for details.
## HIST_STAMPS="mm/dd/yyyy"
#
## Would you like to use another custom folder than $ZSH/custom?
## ZSH_CUSTOM=/path/to/new-custom-folder
#
## Which plugins would you like to load?
## Standard plugins can be found in $ZSH/plugins/
## Custom plugins may be added to $ZSH_CUSTOM/plugins/
## Example format: plugins=(rails git textmate ruby lighthouse)
## Add wisely, as too many plugins slow down shell startup.
#plugins=(git)
#
#source $ZSH/oh-my-zsh.sh
#
## User configuration
#
## export MANPATH="/usr/local/man:$MANPATH"
#
## You may need to manually set your language environment
## export LANG=en_US.UTF-8
#
## Preferred editor for local and remote sessions
## if [[ -n $SSH_CONNECTION ]]; then
##   export EDITOR='vim'
## else
##   export EDITOR='nvim'
## fi
#
## Compilation flags
## export ARCHFLAGS="-arch $(uname -m)"
#
## Set personal aliases, overriding those provided by Oh My Zsh libs,
## plugins, and themes. Aliases can be placed here, though Oh My Zsh
## users are encouraged to define aliases within a top-level file in
## the $ZSH_CUSTOM folder, with .zsh extension. Examples:
## - $ZSH_CUSTOM/aliases.zsh
## - $ZSH_CUSTOM/macos.zsh
## For a full list of active aliases, run `alias`.
##
## Example aliases
## alias zshconfig="mate ~/.zshrc"
## alias ohmyzsh="mate ~/.oh-my-zsh"
## source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
#
## To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
## [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
#
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

#-------------------------------------------- sylvan fralkin conf

autoload -U colors && colors
bindkey -e
PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "

source <(fzf --zsh)
finder() {
    open .
}

zle -N finder
bindkey '^f' finder

normalize() {
  ffmpeg -i "$1" -af loudnorm=I=-14:TP=-1.0:LRA=11 -c:v copy -c:a aac -b:a 192k output.mp4
}


# Basic auto/tab complete:
autoload -U compinit && compinit
autoload -U colors && colors
zmodload zsh/complist

_comp_options+=(globdots)		# Include hidden files.

export PATH="/Users/sylvanfranklin/.local/share/bob/nvim-bin/:$PATH"
export PATH="/Users/sylvanfranklin/Library/Python/3.9/bin/:$PATH"
export PATH="/Users/sylvanfranklin/.local/bin:$PATH"

alias love="/Applications/love.app/Contents/MacOS/love"
alias cmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
alias venv="source .venv/bin/activate"
alias vim=nvim
alias vi="nvim"
alias im="nvim"
alias nm="neomutt"
alias p="poetry"
alias mb="~/Documents/projects/microbrew/target/debug/microbrew" 
alias yt="lux"
alias dl="lux"
alias rip="yt-dlp -x --audio-format=\"mp3\""

export EDITOR="nvim"
export MANPAGER="nvim +Man!"

# edit command line
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line
export HISTIGNORE='exit:cd:ls:bg:fg:history:f:fd:vim'

MAILSYNC_MUTE=1


lazy_load_nvm() {
  unset -f node nvm
  export NVM_DIR=~/.nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}

node() {
  lazy_load_nvm
  node $@
}

nvm() {
  lazy_load_nvm
  node $@
}

GG_HOME=~/documents/work
export GG_HOME=${GG_HOME} 
export GG_API=${GG_HOME}/gg-api 
export GG_WEB=${GG_HOME}/esports-web/gg-web 
export GG_EW=${GG_HOME}/esports-web 
export GG_GCP_USERNAME="sylvan" 
export NODE_ENV=development 
alias cd-ew="cd ${GG_EW}" 
alias cd-w="cd ${GG_WEB}" 
alias cd-a="cd ${GG_API}"
alias src="source ~/.config/zsh/.zshrc"
alias phpcs="${GG_API}/lib/vendor/bin/phpcs"
alias phpmd="${GG_API}/lib/vendor/bin/phpmd"
export PATH=${GG_API}/ops/bin:$PATH
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH" 
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH" 



# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sylvanfranklin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sylvanfranklin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sylvanfranklin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sylvanfranklin/google-cloud-sdk/completion.zsh.inc'; fi

# Load zsh-syntax-highlighting; should be last.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


