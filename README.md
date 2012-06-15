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

Configuration
=============

Configuration is located in /etc/xinit/xinit.cfg with sensible defaults.

Change Log
==========

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
