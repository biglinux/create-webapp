#!/bin/bash

cd ~

icon=$(yad --center --title $"Selecione o ícone" \
		   --window-icon folder --width 640 \
		   --height 480 --file --add-preview \
		   --image-filter=Icon)

echo "<META http-equiv=\"refresh\" content=\"0;URL=index-create.sh.htm?$icon\">"


