# -------------------------------
# Oh-My-Zsh 基础配置
# -------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  vi-mode
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-navigation-tools
  zsh-interactive-cd
)

# -------------------------------
# Powerlevel10k 配置
# -------------------------------
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

# -------------------------------
# Load Oh-My-Zsh
# -------------------------------
source $ZSH/oh-my-zsh.sh

# zsh-syntax-highlighting MUST load last
source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# -------------------------------
# PATH & 基础环境变量
# -------------------------------
export JAVA_HOME="/Users/ryan/Library/Java/JavaVirtualMachines/tcjdk/Contents/Home"

export MAVEN_HOME="/Users/ryan/environment/apache-maven-3.6.3"
export PATH="$PATH:$MAVEN_HOME/bin"

# Lua / npm-global / Antigravity / Docker
export PATH="/opt/homebrew/opt/lua@5.3/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"

# yazi
export PATH="$HOME/.config/yazi:$PATH"

# Rust
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# broot
source ~/.config/broot/launcher/bash/br


# Go 环境
export GOROOT="/Users/ryan/environment/go/go1.23.6"
export GOPATH="/Users/ryan/environment/go/go1.23.6"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOROOT/bin:$GOBIN"


# -------------------------------
# Aliases
# -------------------------------
alias o="open -a"
alias typora="open -a typora"
alias lc="leetcode"
alias jos="joshuto"
alias ya="$HOME/.config/yazi/ya"
alias yazi="$HOME/.config/yazi/yazi"

# 自定义 env
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"


# -------------------------------
# nvm
# -------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh"


# -------------------------------
# Fiddler
# -------------------------------
if [ -n "$FE_STARTED" ] && [ -s '/Applications/Fiddler Everywhere.app/Contents/Resources/app/out/assets/scripts/startup-mac.sh' ] && [ "$STARTUP_SOURCED" != "true" ] ; then
    source '/Applications/Fiddler Everywhere.app/Contents/Resources/app/out/assets/scripts/startup-mac.sh'
    STARTUP_SOURCED="true"
fi


# -------------------------------
# Conda 放最后（避免污染 Node/Go）
# -------------------------------
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


# -------------------------------
# 🌟 智能代理代理切换
# -------------------------------
PROXY_HOST="127.0.0.1"
PROXY_PORT="7897"

function proxy() {
  if nc -z $PROXY_HOST $PROXY_PORT 2>/dev/null; then
    export http_proxy="http://$PROXY_HOST:$PROXY_PORT"
    export https_proxy="http://$PROXY_HOST:$PROXY_PORT"
    export all_proxy="socks5://$PROXY_HOST:$PROXY_PORT"
    echo "🟢 Proxy enabled → $PROXY_HOST:$PROXY_PORT"
  else
    echo "🔴 Proxy port $PROXY_PORT is not open → Proxy NOT enabled"
  fi
}

function unproxy() {
  unset http_proxy https_proxy all_proxy
  echo "⚪ Proxy disabled"
}