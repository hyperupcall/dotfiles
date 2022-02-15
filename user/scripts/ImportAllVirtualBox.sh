# shellcheck shell=bash

shopt -s nullglob

register() {
  local dir="$1"

  for file in "$dir"/*.vbox; do
    printf '%s\n' "Adding '$file'"
    VBoxManage registervm "$file"
  done
}


main() {
  local flag_unregister='no'

  for arg; do case $arg in
    --help|-h) printf '%s\n' "Usage: $0 [-h|--help] [--unregister] (add is default)" ;;
    --unregister) flag_unregister='yes'
  esac done
  
  if [ "$flag_unregister" = 'yes' ]; then
    while IFS= read -r line; do
      printf '%s\n' "Removing '${line}'"
      local uuid="${line%\}}"
      uuid=${uuid##*\{}
      VBoxManage unregistervm "$uuid"
    done < <(VBoxManage list vms)
    return
  fi

  local virtualbox_dir="/storage/vault/rodinia/Virtual_Machines"
  
  # Add all 
  for group_dir in "$virtualbox_dir"/*/; do
    register "$group_dir"
    local group_name="${group_dir%/}"; group_name=${group_name##*/}
    for vm_dir in "$group_dir"*/; do
      register "$vm_dir"
    done
  done
}

main "$@"

