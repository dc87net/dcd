


unzip(){
  dest="$(mktemp -d)" && log "Output destination:  ${CYAN}$dest${NC}" || { log "${RED}Error${NC}"}; exit 1; }
  aa extract -v -i '$*' -o "$dest";
}

