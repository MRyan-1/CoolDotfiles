export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  vi-mode
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-navigation-tools
  zsh-interactive-cd
)

# Powerlevel10k configs
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_CONTEXT_TEMPLATE='%n'
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='white'
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{014}\u2570%F{cyan}\uF460%F{073}\uF460%F{109}\uF460%f "
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_NODE_VERSION_BACKGROUND="002"
POWERLEVEL9K_NODE_VERSION_FOREGROUND="black"
POWERLEVEL9K_GO_VERSION_BACKGROUND="001"
POWERLEVEL9K_GO_VERSION_FOREGROUND="black"
POWERLEVEL9K_WIFI_BACKGROUND="003"
POWERLEVEL9K_WIFI_FOREGROUND="black"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context ssh dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status proxy anaconda node_version go_version wifi)

# load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# zsh-syntax-highlighting MUST load last
source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# broot
source ~/.config/broot/launcher/bash/br

# PATH clean
export PATH="/opt/homebrew/opt/lua@5.3/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
export PATH="/Applications/Docker.app/Contents/Resources/bin/:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"

# Fiddler
if [ -n "$FE_STARTED" ] && [ -s '/Applications/Fiddler Everywhere.app/Contents/Resources/app/out/assets/scripts/startup-mac.sh' ] && [ "$STARTUP_SOURCED" != "true" ] ; then
    source '/Applications/Fiddler Everywhere.app/Contents/Resources/app/out/assets/scripts/startup-mac.sh'
    STARTUP_SOURCED="true"
fi

# conda (keep last)
# >>> conda initialize >>>
__conda_setup="$('/Users/ryan/anaconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ryan/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/ryan/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ryan/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
