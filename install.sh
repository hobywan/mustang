#!/bin/bash

# Copyright 2018, Hoby Rakotoarivelo.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# The Software is provided “as is”, without warranty of any kind, express
# or implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose and noninfringement.
# In no event shall the authors or copyright holders be liable for any claim,
# damages or other liability, whether in an action of contract, tort or
# otherwise, arising from, out of or in connection with the software or
# the use or other dealings in the Software.

IDE_SETTINGS_ROOT=""
DETECTING_PATH=""
COLORS_DIR=""

set_paths() {
  if [ "$(uname)" == "Darwin" ]; then
    IDE_SETTINGS_ROOT="$HOME/Library/Preferences"
    DETECTING_PATH="options/project.default.xml"
    COLORS_DIR="colors"
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    IDE_SETTINGS_ROOT="$HOME"
    DETECTING_PATH=".config/options/project.default.xml"
    COLORS_DIR=".config/colors"
  else
    echo "Please use install.bat script instead"
    exit 0
  fi
}

copy_scheme() {
  ide=$1
  scheme=$2
  if [ -f "$IDE_SETTINGS_ROOT/$ide/$DETECTING_PATH" ]; then
    dest=$IDE_SETTINGS_ROOT/$ide/$COLORS_DIR
    if [ ! -d "$dest" ]; then
      mkdir "$dest"
    fi
    cp "$scheme" "$dest"
    if [ "$?" = "0" ]; then
      echo "Mustang scheme successfully installed for "$ide""
    fi
  fi
}

detect_and_copy() {
  found=false
  for ide in `ls -A "$IDE_SETTINGS_ROOT"`; do
    if [[ $ide =~ ^CLion.*$ ]]; then
      found=true
      copy_scheme "$ide" "mustang.clion.icls"
    fi
    if [[ $ide =~ ^Idea.*$ ]]; then
      found=true
      copy_scheme "$ide" "mustang.idea.icls"
    fi
  done

  if [ ! $found ]; then
    echo "No supported IDE detected"
    exit 1
  fi
}

# run
set_paths
detect_and_copy