#!/bin/bash

NAMEDESK=$(echo "$1" | sed 'y/áÁàÀãÃâÂéÉêÊíÍóÓõÕôÔúÚüÜçÇ/aAaAaAaAeEeEiIoOoOoOuUuUcC/' | tr '[:upper:]' '[:lower:]' | sed 's|\ |-|g;s|\/|-|g')

if [ "$(echo "$2" | egrep "(http|https)://")" != "" ]; then
	CUT_HTTP=$(echo "$2" | sed 's/https:\/\///;s/http:\/\///' | tr '/' '_' | sed 's/_/__/1;s/_$//;s/_$//')
elif [ "$2" = "" ]; then
	kdialog --error $"Você não inseriu a url!\n Por favor, verifique e tente novamente!"
	echo "<META http-equiv=\"refresh\" content=\"0;URL=index-create.sh.htm\">"
	exit
else
	kdialog --error $"A url inserida é inválida!\n Por favor, verifique sua url e tente novamente!"
	echo "<META http-equiv=\"refresh\" content=\"0;URL=index-create.sh.htm\">"
	exit
fi

ICONFILE=$(echo "$3" | awk -F'/' '{print $NF}')
if [ -z "$3" ]; then 
	ICON_FILE="preferences-web-browser-shortcuts"
else
	mkdir -p $HOME/.local/share/icons/webapp
	cp $3 $HOME/.local/share/icons/webapp
	ICON_FILE="$HOME/.local/share/icons/webapp/$ICONFILE"
fi 

if [ ! -e $HOME/.config/menus/applications-merged/custom-applications.menu ]; then 
mkdir -p $HOME/.config/menus/applications-merged
echo "<!DOCTYPE Menu PUBLIC \"-//freedesktop//DTD Menu 1.0//EN\"
\"http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd\">
<Menu>
	<Name>Applications</Name>
	<Menu>
		<Name>Web Apps Custom</Name>
		<Directory>web-apps-custom.directory</Directory>
			<Include>
				<Filename>$NAMEDESK-webapp-biglinux.desktop</Filename>
			</Include>
	</Menu>
</Menu>" > $HOME/.config/menus/applications-merged/custom-applications.menu
chmod +x $HOME/.config/menus/applications-merged/custom-applications.menu
mkdir -p $HOME/.local/share/desktop-directories
echo "[Desktop Entry]
Type=Directory
Name=Web apps Custom
Icon=preferences-web-browser-shortcuts" > $HOME/.local/share/desktop-directories/web-apps-custom.directory

else 
	if [ "$(grep -R "$2$" $HOME/.local/share/applications)" != "" -o \
		 "$(grep "$NAMEDESK-webapp-biglinux.desktop" $HOME/.config/menus/applications-merged/custom-applications.menu)" != "" ]; then
		 	
		kdialog --sorry $"Ops...! Esse WebApp já existe!\nTente mudar o nome ou a url. "
		echo "<META http-equiv=\"refresh\" content=\"0;URL=index-create.sh.htm\">"
		exit
	else
		sed -i '9i \\t\t\t\t<Filename>'"$NAMEDESK"'-webapp-biglinux.desktop</Filename>' \
		$HOME/.config/menus/applications-merged/custom-applications.menu
	fi
fi

mkdir -p $HOME/.local/share/applications
echo "#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Terminal=false
Type=Application
Name=$1
Exec=/usr/bin/biglinux-webapp --class=\"$CUT_HTTP,Chromium-browser\" --profile-directory=Default --app=$2
Icon=$ICON_FILE
StartupWMClass=$CUT_HTTP" > $HOME/.local/share/applications/"$NAMEDESK"-webapp-biglinux.desktop

kdialog --msgbox $"O WebApp personalizado foi criado com sucesso!\nCaso não estiver no menu refaça login no sistema!"
kdialog --yesno $"Você deseja criar outro WebApp personalizado?"

if [ "$?" != "0" ]; then	
	echo "<META http-equiv=\"refresh\" content=\"0;URL=index.sh.htm\">"
	exit
else 
	echo "<META http-equiv=\"refresh\" content=\"0;URL=index-create.sh.htm\">"
	exit
fi
	












