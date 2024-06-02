#!/usr/bin/env bash


readonly mainString=$(cat <<< "
#!/usr/bin/env zsh

source \"/opt/script/etc/colors.sh\"
eval bash -c \"/opt/script/bin/$*\"
" | base64)


b64text(){
  cat <<< "#!/usr/bin/env zsh

  source \"/opt/script/etc/colors.sh\"
  eval bash -c \"/opt/script/bin/$*\"
" | base64
}

cat <<< $(b64text)

eval $("b64text")
log "done!"