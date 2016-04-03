#!/bin/bash

# Set Colors
e_header() { printf "\n$(tput setaf 141)%s$(tput sgr0)\n" "$@"
}
e_success() { printf "$(tput setaf 71)👌 %s$(tput sgr0)\n" "$@"
}
e_error() { printf "$(tput setaf 1)✖ %s$(tput sgr0)\n" "$@"
}
e_warning() { printf "$(tput setaf 153)%s$(tput sgr0)\n" "$@"
}

  # Set Directory Locations
  # dropbox_assets_dir: This is the location of your 'assets' directory
  # backup_dir: Desired path to a backup folder goes here here.

  assets_dir="$HOME"/Dropbox/Mackup/
  backup_dir="$HOME"/Desktop/DotfileBackup/$(date "+%Y-%m-%d-%H_%M")

  sudo -v # ask for password only at the beginning

  e_header "---------- BEGINNING CONFIG SCRIPT ----------"
  e_header "Hang tight.......here we go....."

  # 2.    Symlinks to ~/Dotfiles
  #
  #       Takes all files found in "$assets_dir"/dotFiles/
  #       and symlinks them to ~/

  ASSETS="$assets_dir"/.juridotfiles/*
  SOURCE="$assets_dir"/.juridotfiles/
  DEST="$HOME"/

# Deleting .DS_Store Files
  e_header "---------- Deleting .DS_Store Files ----------"
  cd $HOME/Dropbox/Mackup/.juridotfiles
  find . -type f -name '*.DS_Store' -ls -delete
  e_header "---------- Symlinking Dotfiles ----------"

  shopt -s dotglob    #show dot files
  if [ ! -d "$SOURCE" ]; then
    e_error "Can't find source directory: $SOURCE"
  else
    for f in $ASSETS
    do
      if [ -L "$DEST"`basename "$f"` ]; then
        e_success "Already Linked: "$DEST"`basename "$f"`"
      else
        e_warning "Linking: `basename "$f"`"
        if [ -f "$DEST"`basename "$f"` ]; then
          if [ ! -d "$backup_dir"/dotfiles ]; then
            mkdir -p "$backup_dir"/dotfiles
          fi
          mv "$DEST"`basename "$f"` "$backup_dir"/dotfiles/`basename "$f"`
          ln -s "$SOURCE"`basename "$f"` "$DEST"`basename "$f"`
        else
          ln -s "$SOURCE"`basename "$f"` "$DEST"`basename "$f"`
        fi
      fi
    done
  fi
  rm ~/symlink_dotfiles.sh
  rm ~/.git
  
  source $HOME/.bash_profile
  shopt -u dotglob    #reset dotglob
  unset ASSETS
  unset SOURCE
  unset DEST

  #
  # Notify if Backups were created of any files above
  #
  e_header "---------- Processing Backups  ----------"
  if [ -e $backup_dir ]; then
    e_warning "Backups moved to "$backup_dir""
  else
    e_success "No Backups Created"
  fi
  e_header "---------- YAY! ALL DONE  ----------"
