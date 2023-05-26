
export ZSH="/Users/ryan/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# ZSH_THEME="jonathan"
ZSH_THEME="powerlevel10k/powerlevel10k"


plugins=(
git
zsh-syntax-highlighting
zsh-autosuggestions
zsh-navigation-tools
zsh-interactive-cd
 )


POWERLEVEL9K_MODE='nerdfont-complete'
ZSH_THEME="powerlevel10k/powerlevel10k"
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

# 在终端下执行下面的命令, 可以看到代号对应的颜色
# for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done


source $ZSH/oh-my-zsh.sh

source ~/.bash_profile

# User configuration

source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


source /Users/ryan/.config/broot/launcher/bash/br

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh