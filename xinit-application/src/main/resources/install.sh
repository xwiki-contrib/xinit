#!/bin/bash


#################################
#				#
#	xinit install script	#
#				#
#################################

# load the function file
if [[ ! -e var/lib/xinit/functions ]]; then

echo "Error: I can't find var/lib/xinit/functions file."
exit 12

fi

if [[ ! -e var/lib/xinit/vars ]]; then

echo "Error: I can't find var/lib/xinit/vars file."
exit 15

fi

. var/lib/xinit/functions
. var/lib/xinit/vars

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

# check dependencies
check_dependencies;

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
    chown -R "${DEFAULT_TOMCAT_USER}:${DEFAULT_TOMCAT_USER}" "${LIB_DIR}"
	

else

	echo "Installing lib dir $LIB_DIR..."
	cp -r var/lib/xinit $LIB_DIR
    chown -R "${DEFAULT_TOMCAT_USER}:${DEFAULT_TOMCAT_USER}" "${LIB_DIR}"

fi


if [[ -e /etc/init.d/xwiki.sh ]]; then

    echo "xwiki.sh script already exists! Installing a new one ..."
    rm -f /etc/init.d/xwiki.sh
    cp etc/init.d/xwiki.sh /etc/init.d/xwiki.sh
    chmod a+x /etc/init.d/xwiki.sh
    # test
    chown -R "${DEFAULT_TOMCAT_USER}:${DEFAULT_TOMCAT_USER}" /etc/init.d/xwiki.sh

else

    echo "Installing xwiki.sh script ..."
    cp etc/init.d/xwiki.sh /etc/init.d/xwiki.sh
    chmod a+x /etc/init.d/xwiki.sh
    # test
    chown -R "${DEFAULT_TOMCAT_USER}:${DEFAULT_TOMCAT_USER}" /etc/init.d/xwiki.sh

fi

if [[ -n ${USE_SYSTEMD} ]] ; then

    if [[ -e /etc/systemd/system/xwiki.service ]]; then

	    echo "xwiki.service already exists! Installing a new one ..."
	    rm -f /etc/systemd/system/xwiki.service
	    cp etc/systemd/xwiki.service /etc/systemd/system/xwiki.service
        sed -i "s/XWIKI_USER/${DEFAULT_TOMCAT_USER}/" /etc/systemd/system/xwiki.service
        sed -i "s/XWIKI_GROUP/${DEFAULT_TOMCAT_USER}/" /etc/systemd/system/xwiki.service
        systemctl daemon-reload
        systemctl enable xwiki.service

    else

	    echo "Installing xwiki.service ..."
	    cp etc/systemd/xwiki.service /etc/systemd/system/xwiki.service
        sed -i "s/XWIKI_USER/${DEFAULT_TOMCAT_USER}/" /etc/systemd/system/xwiki.service
        sed -i "s/XWIKI_GROUP/${DEFAULT_TOMCAT_USER}/" /etc/systemd/system/xwiki.service
        systemctl daemon-reload
        systemctl enable xwiki.service

    fi

fi

tomcat_service=$(ls /etc/systemd/system/multi-user.target.wants/tomcat*.service 2> /dev/null)
if [[ -n ${tomcat_service} ]]  ; then
   echo "Tomcat service found. Disabling it ..."
   systemctl stop "${tomcat_service%%##*/}"
   systemctl disable "${tomcat_service%%##*/}"
fi

if [[ ! -d ${VAR_DIR} ]] ; then
    echo "Creating xinit var folder"
    mkdir ${VAR_DIR}
    chown  -R "${DEFAULT_TOMCAT_USER}:${DEFAULT_TOMCAT_USER}" "${VAR_DIR}"
fi

if [[ ! -f ${LOG_FILE} ]] ; then
    echo "Creating xinit log file"
    touch ${LOG_FILE}
    chown  -R "${DEFAULT_TOMCAT_USER}:${DEFAULT_TOMCAT_USER}" "${LOG_FILE}"
fi

if [[ ${INSTALL_CRONJOB} -eq "true" ]] ; then
cronjob=$(cat << EOF
*/1 * * * * tomcat /etc/init.d/xwiki.sh check-proc > /dev/null 2> /dev/null
*/5 * * * * tomcat /etc/init.d/xwiki.sh check-http > /dev/null 2> /dev/null
EOF
)
    echo "Creating cronjob"
    echo "${cronjob}" | crontab -u ${DEFAULT_TOMCAT_USER} -

fi

if [[ ! -d ${CONF_DIR} ]]; then

	echo "Installing xinit default configuration! Please edit /etc/xinit/xinit.cfg as you need!"
	mkdir ${CONF_DIR}
	cp -f etc/xinit/xinit.cfg /etc/xinit/xinit.cfg
    chown -R "${DEFAULT_TOMCAT_USER}:${DEFAULT_TOMCAT_USER}" "${CONF_DIR}"
	echo "Installation Finished!"

elif [[ -e "${CONF_DIR}/${XWIKI_CONF_FILE}" ]]; then

	echo "A previous configuration of xinit already exists. I'll not touch it!"
	echo "Installation Finished!"

else

	echo "Installing xinit default configuration! Please edit /etc/xinit/xinit.cfg as you need!"
	cp -f etc/xinit/xinit.cfg /etc/xinit/xinit.cfg
    chown -R "${DEFAULT_TOMCAT_USER}:${DEFAULT_TOMCAT_USER} ${CONF_DIR}"
    echo "Installation Finished!"

fi
}

# Function used to migrate xinit conf (vers <= 0.0.17 ) to version >= 1.0
migrate() 
{
	OLD_CONFIGURATION_FILE='/etc/xinit/xinit.cfg';
	NEW_CONFIGURATION_FILE='/etc/xinit/xinit.cfg.new'
	DEFAULT_NEW_CONFIGURATION_FILE='var/lib/xinit/default.cfg';

	if [[ ! -e $OLD_CONFIGURATION_FILE ]]; then

		echo "Error: I was not able to find old conf file $OLD_CONFIGURATION_FILE"
		exit 13
	fi

	if [[ ! -e $DEFAULT_NEW_CONFIGURATION_FILE ]]; then

                echo "Error: I was not able to find the default new file $DEFAULT_NEW_CONFIGURATION_FILE"
                exit 14
        fi

	./var/lib/xinit/migrate $OLD_CONFIGURATION_FILE $DEFAULT_NEW_CONFIGURATION_FILE $NEW_CONFIGURATION_FILE
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
                echo " usage: ./install.sh [ --install | --update | --migrate ]"
                echo
                exit 1

esac

