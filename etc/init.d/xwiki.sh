#!/bin/bash

### BEGIN INIT INFO
# Provides:             java
# Required-Start:       $remote_fs $syslog
# Required-Stop:        $remote_fs $syslog
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    Xinit script to manage XWiki availability.
### END INIT INFO

#################################
#				#
#	XWiki StartUp Script	#
#				#
#################################

if [[ $UID -ne 0 ]]; then

	echo
	echo " Error: Only root can run this script! Exiting ..."
	echo
	exit 2

fi

if [[ ! -e /var/lib/xinit/vars ]]; then

	echo
	echo " Error: No vars fils was found! Exiting ..."
	echo
	exit 1

else

	. /var/lib/xinit/vars

fi

for lib in $LIBS_FILE; do

	if [[ ! -e "${LIB_DIR}/${lib}" ]]; then

		echo
		echo " Error: Could not find lib file: ${LIB_DIR}/${lib} . Exiting ..." 
		echo
		exit 1

	else

		. ${LIB_DIR}/${lib}

	fi

done

if [[ -e ${CONF_DIR}/${XWIKI_CONF_FILE} ]]; then

	. ${CONF_DIR}/${XWIKI_CONF_FILE} 

else

	echo
	echo " Warning: No conf file (${CONF_DIR}/${XWIKI_CONF_FILE}) was found. Using default configuration ..."
	echo

fi

if [[ ! -d ${VAR_DIR} ]]; then
	echo " Creating var folder: ${VAR_DIR} ..."
	mkdir ${VAR_DIR}
fi

export TOMCAT_HOME JAVA_HOME CATALINA_OPTS TOMCAT_USER LANG CATALINA_PID

if [[ -z "$1" ]]; then

	show_help
	exit 3

fi

#while [[ -n "$1" ]]; do
case "$1" in 
	start)
		start_tomcat
		;;
	stop)
		stop_tomcat
		;;
	restart)
		restart_tomcat
		;;
	report) 
		send_report
		;;
	show-report)
		show_report
		;;
	list-parameters)
		list_parameters
		;;
	check-proc)
		check_proc
		;;
	check-http)
		check_http
		;;
	check-openoffice)
		check_openoffice
		;;
	test-http)
		TEST_HTTP="1"
		check_http $TEST_HTTP
		;;
	test-proc)
		TEST_PROC="1"
		check_proc $TEST_PROC
		;;
	test-openoffice)
		TEST_OPENOFFICE="1"
		check_openoffice $TEST_OPENOFFICE
		;;
	maintenance)
		ACTION="$2"
		## If $2 is empty, we switch the actual state, to 'on' or 'off'
		if [[ $ACTION =~ (on|off|^$) ]] ; then
		    maintenance $ACTION
		else
		    show_help
		    exit 1
		fi
		;;
	sanitycheck-mysql)
		run_sanitycheck_mysql
		;;
	spamdetection-mysql)
		run_spamdetection_mysql
		;;
	check-install)
		check_install
		;;
	check-dep)
		check_dependencies
		;;
	nagios-info)
		nagios_info
		;;
	version)
		echo ""
		echo " Xinit version $VERSION"
		echo " XWiki `cat ${XWIKI_INSTALL_DIR}/WEB-INF/version.properties`"
		echo
		;;
	*)
		show_help
		exit 1
esac
#done
