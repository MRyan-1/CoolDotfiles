export JAVA_HOME=/Users/ryan/Library/Java/JavaVirtualMachines/tcjdk/Contents/Home
export MAVEN_HOME=/Users/ryan/environment/apache-maven-3.6.3
export PATH=$PATH:$MAVEN_HOME/bin
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
. "$HOME/.cargo/env"
alias o="open -a"
alias typora="open -a typora"
alias ot="open -a typora"
alias libreoffice="open -a libreoffice"
alias ol="open -a libreoffice"
alias oi="open -a IINA"
alias iina="open -a IINA"
alias keynote="open -a keynote"
alias kn="open -a keynote"
alias word="open -a 'Microsoft word'"
alias lc="leetcode"
alias jos="joshuto"
source /Users/ryan/.config/broot/launcher/bash/br
alias ya="/Users/ryan/.config/yazi/yazi"

# FIDDLER_EVERYWHERE_SCRIPT_START
if [ -n "$FE_STARTED" ] && [ -s '/Applications/Fiddler Everywhere.app/Contents/Resources/app/out/assets/scripts/startup-mac.sh' ] && [ "$STARTUP_SOURCED" != "true" ] ; then
    source '/Applications/Fiddler Everywhere.app/Contents/Resources/app/out/assets/scripts/startup-mac.sh'
    STARTUP_SOURCED="true"
fi
# FIDDLER_EVERYWHERE_SCRIPT_END