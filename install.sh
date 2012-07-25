#!/bin/bash


#################################
#				#
#	xinit install script	#
#				#
#################################

xinit_update ()
{
	if [[ -e /var/lib/xinit/vars ]]; then	

		installed_xinit_version="`grep VERSION /var/lib/xinit/vars | cut -d = -f 2`"
		current_xinit_version="`grep VERSION var/lib/xinit/vars | cut -d = -f 2`"

		if [[ $installed_xinit_version != $current_xinit_version ]]; then

			xinit_install

		else

			echo
			echo " Xinit is up to date. Xinit version: $installed_xinit_version"
			echo
			exit 0
		fi

	else

		echo
		echo " Xinit is not installed or the installation is corrupted!"
		echo
		exit 4

	fi 

}

xinit_install ()
{

if [[ ! -e var/lib/xinit/vars ]]; then
	
	echo
	echo " Couldn't find vars file! Please go into xinit folder and run install.sh!"
	echo
	exit 1

else

	. var/lib/xinit/vars

fi

if [[ -d $LIB_DIR ]]; then

	echo "Lib dir ($LIB_DIR) already exists. Installing the last one ..."
	rm -rf $LIB_DIR
	cp -r var/lib/xinit $LIB_DIR
	

else

	echo "Installing lib dir $LIB_DIR..."
	cp -r var/lib/xinit $LIB_DIR

fi

if [[ -e /etc/init.d/xwiki.sh ]]; then

	echo "xwiki.sh script already exists! Installing a new one ..."
	rm -f /etc/init.d/xwiki.sh
	cp etc/init.d/xwiki.sh /etc/init.d/xwiki.sh
	chmod a+x /etc/init.d/xwiki.sh

else

	echo "Installing xwiki.sh script ..."
	cp etc/init.d/xwiki.sh /etc/init.d/xwiki.sh
	chmod a+x /etc/init.d/xwiki.sh

fi

if [[ ! -d ${CONF_DIR} ]]; then

	echo "Installing xinit default configuration! Please edit /etc/xinit/xinit.cfg as you need!"
	mkdir ${CONF_DIR}
	cp -f etc/xinit/xinit.cfg /etc/xinit/xinit.cfg
	echo "Installation Finished!"

elif [[ -e "${CONF_DIR}/${XWIKI_CONF_FILE}" ]]; then

	echo "A previous configuration of xinit already exists. I'll not touch it!"
	echo "Installation Finished!"

else

	echo "Installing xinit default configuration! Please edit /etc/xinit/xinit.cfg as you need!"
	cp -f etc/xinit/xinit.cfg /etc/xinit/xinit.cfg
        echo "Installation Finished!"

fi
}

migrate() 
{
	OLD_CONFIGURATION_FILE='/etc/xinit/xinit.cfg';
	DEFAULT_NEW_CONFIGURATION_FILE='var/lib/xinit/default.cfg';
	NEW_CONFIGURATION_FILE=$OLD_CONFIGURATION_FILE
	. var/lib/xinit/migrate $OLD_CONFIGURATION_FILE $DEFAULT_NEW_CONFIGURATION_FILE $NEW_CONFIGURATION_FILE
}

case $1 in
        --install)
                        xinit_install
                        ;;
        --update)
                        xinit_update
                        ;;
	--migrate)
			migrate
			;;
        *)
                echo ""
                echo " usage: ./install.sh [ --install | --update | --migrate]"
                echo
                exit 1

esac

