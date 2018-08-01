#!/bin/bash

# link files
link_file () {
  file=$1
  if [[ -f "$HOME/$file" || -L "$HOME/$file" ]]; then
    realpath=$( realpath "$HOME/$file" )
    mv -f "$realpath" "$HOME/$file.bak"
  fi

  fullpath=$( readlink -m $file)
  ln -s "$fullpath" "$HOME/$file"
}

link_file ".Rprofile"
link_file ".Renviron"
link_file ".spacevim"
link_file ".gitconfig"

link_file .vim/autoload/unite
link_file .vim/autoload/unite
