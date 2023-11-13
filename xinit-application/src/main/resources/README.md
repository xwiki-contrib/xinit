Installation
============

Linux
-----

Simply run :

    $ sudo ./install.sh --install

OSX
---

You will need to install a `pidof` utility. For example [this one](http://hints.macworld.com/article.php?story=20030618114543169)

Then :

    $ sudo mkdir /etc/init.d
    $ sudo ./install.sh --install

Dependencies
============

These are always optional and can be skipped during the install, but some features may then not work as expected.

* curl
* pidof
* mailx
* mysql-client

Configuration
=============

Configuration is located in /etc/xinit/xinit.cfg with sensible defaults.

Change Log
==========
### Xinit Version 1.3 - 08/11/2023 ###
* Added the possibility to run xinit with a non-root user.
* Added the possibility to set the cronjob checks via xwiki.sh script.
* Increased default values for MEM_START and MEM_MAX variables.
* Every start/stop/restart action is now performed with systemctl.

### Xinit Version 1.2.6 - 17/06/2015 ###
* Added a force parameter to the check/test_http to ignore the CHECK_HTTP variable.
* Added an option to remove the tomcat temp folder contents on start (enabled by default)
* Add a "check" option to the maintenance switch to return the state of the maintenance mode

### Xinit Version 1.2.5 - 04/06/2015 ###
* Created a new configuration option for XInit's Var folder (/var/run/xinit by default) which gets created automatically if absent
* Moved maintenance to ${VAR_DIR}

### Xinit Version 1.2.4 - 08/07/2014 ###
* Fixed a bug which prevented automatic restarts when catalina.out was missing
* Added support for Thread dump analysis via webservices (using jthreader.xwiki.com as an example)

### Xinit Version 1.2.3 - 28/02/2014 ###

* Maintenance mode is now activated for a certain amount of time when the wiki is restart, manually or not. If the maintenance file already exists, it is not deleted.
* Maintenance mode now has its own option in xwiki.sh's commands. See help for more details.
* During a crash detected by check_proc or check_http, mail's subject is prefixed by a short status if a Memory Heap/PermGen space issue is found.
* A list of most common pages called during the crash is gathered at the very end of the mail. It's made on the analysis of Thread Dump.


### Xinit Version 1.2.2 - 13/12/2013 ###

* Maintenance mode has been added. Simply create /etc/xinit/maintenance file, and the wiki won't be restarted by check_xwiki & check_proc commands.
* Check_proc has been fixed. Every check related to that check_proc were run, now only the first match restarts the wiki.
* By default, Java will prefer IPv4, to prevent IPv6-related bugs. In case of full IPv6 installation, the java option -Djava.net.preferIPv4Stack should be removed from CATALINA_OPTS variable.
* Another bug about multiple tomcat instances being started has been fixed.


### Xinit Version 1.2.1 - 23/04/2013 ###

* A DNS trace in case domain name resolution fails using the 'dig' command if it exists

### Xinit Version 1.2 - 19/02/2013 ###

* Possibility to match several return codes for check-http function (EXPECT_HTTP_RESPONSE_CODE in xinit.cfg).
* (Bug) Curl couldn't detect xwiki unresponsiveness, if a front-end (Apache,Nginx...) wasn't returning an error code 500. Now, total time of the check operation is taken into account.
* Apache status has been added to the get-info function.
* Catalina logfile isn't cleaned anymore after a thread dump performed by get-info function.
* A new function to run a spam detection upon every mysql database of the running instance.
* A new function to run a sanity check upon a mysql database. 
* Some other bugfixes and improvements...

### Xinit Version 1.1 - 27/07/2012 ###

* a new functionality has been added to Xinit to migrate the old configuration (Xinit version <= 0.0.17) to the new version (Xinit >= 1.0)
* a new files has been added var/lib/xinit/migrate
* a new function to check dependencies has also been added. Dependencies can be checked using xwiki.sh --check-dep

### Xinit Version 1.0 - 28/05/2012 ###

* A new major version released
* Major change to check_http function. Now is using curl instead of wget
* Changed function check_http to use response http code and removed the local way to check wiki availability.
* Add the possibility to deactivate mail notifications.
* Section renamed in mail notifications: from "WGET_OUTPUT" in "HTTP_OUTPUT"
* Major change to nagios_info function. It now has a new report format and is able to report xinit version, response and expected http code and also the url used to check the wiki
* Parameters removed:
- HTTP_LOCAL_HOSTNAME
- HTTP_LOCAL_PAGE
- HTTP_LOCAL_PORT
- BASIC_AUTH_USERNAME
- BASIC_AUTH_PASSWORD
- MAKE_FIRST_REQUEST_URL
* Parameters renamed:
- WGET_HTACCESS_USERNAME -> HTACCESS_USERNAME
- WGET_HTACCESS_PASSWORD -> HTACCESS_PASSWORD
* New parameters:
- SEND_MAIL_NOTIFICATION
- EXCEPT_HTTP_RESPONSE_CODE
- USE_DNS
* Unset MAIL parameter.
* Unset CHECK_HTTP_URL parameter.

### Xinit Version 0.0.17 - 02/03/2012 ###

* nagios_info function has been modified to also report local check.
* list_parameters function has been fixed.
* Some parameter description has been updated in xinit.conf
* Print also XWiki version when xwiki.sh is called using 'version' options.

### Xinit Version 0.0.16 - 22/04/2011 ###

Functions Bug Fix:

start_tomcat 
start_openoffice

### Xinit Version 0.0.15 - 22/04/2011 ###

* Add OpenOffice support. Features:
- local management of OO Daemon(OO_SERVER_TYPE=0)
- external management of OO Daemon (OO_SERVER_TYPE=1)
- Added [check|test]-openoffice option to xwiki.sh OO Daemon when using OO_SERVER_TYPE=1
- Automatically stop OO Daemon when tomcat is stopped.(OO_CHECK must be enabled in xinit.cfg. By Default is enabled)

* Impoved stop_tomcat function.
* Added Debian LSB information on xwiki.sh script

### Xinit Version 0.0.14 - 29/11/2010 ###

Fixing a bug in Xinit:
- when USE_BASIC_AUTH=yes the username and passwor for wget were not set in all cases.

### Xinit Version 0.0.13 - 24/11/2010 ###

- add KILL_QUIT_TIME_WAIT parameter to xinit.cfg 
- add nagios-info options to xwiki.sh
* added nagios_info function

- include xinit version in notifications
