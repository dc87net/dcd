
zip1(){
  :
  [[ "$1" ]]&&{
    :;
    log "${YELLOW}AArchiving${NC} ...\n$(aa archive -p -v -d \'"$1"\' | tee /dev/null)"
  };
}

unzip1(){
  :
  dest="$(mktemp -d)" && log "Output destination:  ${CYAN}$dest${NC}" || { log "${RED}Error${NC}"}; exit 1; }
  aa extract -v -i '$*' -o "$dest";
  open "$dest"
}

#### MAIN ####
if [[ "$1" == 'unpack' ]]; then
  shift;
  unzip1 "$@"
else
  zip "$@"
fi