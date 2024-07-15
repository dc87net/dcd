## .ZSHRC ##


PATH=/opt/script:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/X11/bin:/Applications/Wireshark.app/Contents/MacOS:/Applications/iTerm.app/Contents/Resources/utilities


source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.



#########
## dcd ##
#########

export DCD='/opt/script/dcd'
export consoleUser="$(eval echo "~" | awk -F'\/' '{print $NF}')"
export LOGFILE='/var/log/dcterm.log'

[[ -f "$DCD" ]] &&{
  eval "$(dcd colors get)";
  dcd deep
}|| {
  echo -e "\n\nERROR: DCD NOT FOUND!  ==>  Attempting install ...\n";
  (cd /Users/Shared/script/ && exec sudo bash ./install.sh) &&\
  eval "$(dcd colors get)" 2>&1/dev/null
}


 [[ "$(whoami)" == "$(eval echo \"$(basename ~)\")" ]] && [[ -d "$(eval echo $(echo ~))" ]] \
  && {
    log "Detect home folder: ${BGREEN}pass${NC}"; } ||{
    log "Detect home folder: ${RED}fail${NC}: [ '${BRED}$(whoami)${NC}' ? '$(eval echo basename ~)' :  ❌]"
  };

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


## Aliases ##
alias ll='ls -laOG'
alias cdrp='eval cd "$(realpath .)"'

log "${BGREEN}  end of zshrc${NC}" >/dev/null