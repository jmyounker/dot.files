# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$PATH

# Configure brew (Added by UMT onboarding scripts)
export T3_ARCH="arm64"
ARCH="$(uname -m)"
if [[ "$ARCH" == "x86_64" ]]; then
    [ -e /usr/local/Homebrew/bin/brew ] && eval "$(/usr/local/Homebrew/bin/brew shellenv)"
elif [[ "$ARCH" == "arm64" ]]; then
    [ -e /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Configure pyenv if installed (Added by UMT onboarding scripts)
if type pyenv &>/dev/null; then
  eval "$(pyenv init -)"
fi

# Configure pyenv-virtualenv if installed (Added by UMT onboarding scripts)
if type pyenv &>/dev/null; then
  eval "$(pyenv virtualenv-init -)"
fi

# Configure nodenv if installed (Added by UMT onboarding scripts)
if type nodenv &>/dev/null; then
  eval "$(nodenv init -)"
fi

# Configure direnv if installed (Added by UMT onboarding scripts)
if type direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
  export DIRENV_LOG_FORMAT=
fi

# Install zgenom if needed
if [[ ! -d "$HOME/.zgenom" ]]; then
   git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"
fi

# load zgen
source "$HOME/.zgenom/zgenom.zsh"

zgenom autoupdate

if ! zgenom saved; then
  export ZGEN_CUSTOM=$HOME/repos/zsh-plugins
  zgenom oh-my-zsh
  local pkg
  if [ -e $HOME/.zgen.plugins ]; then
      while read pkg; do
          eval $pkg
      done < $HOME/.zgen.plugins
  fi
  zgenom load $ZGEN_CUSTOM/themes/theblobshop
fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

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

# Link to multiple plugins
ZSH_CUSTOM_PATH=(
    "$HOME/repos/zsh-plugins"
    "$HOME/dev/git/sky/div/devenv/zsh"
)

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source ~/.iterm2_shell_integration.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if ! zgenom saved; then
  echo "Creating a zgen save."
  zgenom save
fi

