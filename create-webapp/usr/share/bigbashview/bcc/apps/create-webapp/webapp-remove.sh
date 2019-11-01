#!/bin/bash

if [ "$1" == "all" ]; then
	rm -r $HOME/.local/share/icons/webapp
	rm $HOME/.config/menus/applications-merged/custom-applications.menu
	rm $HOME/.local/share/applications/*webapp*	

	kdialog --msgbox $"Todos WebApps personalizados foram removidos com sucesso!"

	echo "<META http-equiv=\"refresh\" content=\"0;URL=index.sh.htm\">"
	exit
else
	DESK=$(echo "$1" | awk -F "/" '{print $NF}')	
	sed -i '/<Filename>'"$DESK"'</Filename>/d' $HOME/.config/menus/applications-merged/custom-applications.menu
	rm "$1"

	kdialog --msgbox $"O WebApp personalizado foi removido com sucesso!\nCaso ainda estiver no menu refaça login no sistema!"	
	kdialog --yesno $"Você deseja remover outro WebApp personalizado?"

	if [ "$?" != "0" ]; then	
		echo "<META http-equiv=\"refresh\" content=\"0;URL=/usr/share/bigbashview/close.sh\">"
		exit
	else
		echo "<META http-equiv=\"refresh\" content=\"0;URL=index-remove.sh.htm\">"
		exit
	fi
fi
