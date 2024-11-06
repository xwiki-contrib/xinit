#!/bin/bash

# XWiki Installer Script
# ----------------------
# This script installs the XWiki management scripts and configurations.
# It must be run as root.

# Wow colours woW
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo ""
echo "${BOLD}${BLUE}=================================================${RESET}"
echo "${BOLD}${BLUE}                 XWiki Installer                 ${RESET}"
echo "${BOLD}${BLUE}=================================================${RESET}"
echo ""

ask() {
    local prompt default reply
    prompt=$1
    default=$2
    if [ -n "$default" ]; then
        prompt="$prompt [$default]"
    fi
    read -p "$prompt: " reply < /dev/tty
    if [ -z "$reply" ]; then
        reply=$default
    fi
    echo "$reply"
}

# CHECK FOR ROOT FIRST
if [ "$(id -u)" -ne 0 ]; then
    echo "${RED}ERROR: This script must be run as root. Please run with sudo.${RESET}"
    exit 1
fi

# SANITY CHECK - TEST WORKING DIR
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "${YELLOW}This script will install XWiki management scripts and configuration files on your system.${RESET}"
read -p "Do you want to proceed? [y/N]: " proceed
if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

# INTERACTIVE SETUP
echo ""
echo "${BOLD}Configuring xinit.cfg...${RESET}"
echo ""

SEND_MAIL_NOTIFICATION=$(ask "Do you want to send email notifications (yes/no)" "yes")
MAIL=$(ask "Enter email address(es) for notifications (comma-separated)" "admin@example.com")
LOG_LINE_NUMBER=$(ask "How many log lines to include in notifications (default: )" "2000")
LOG_FILE=$(ask "Where the Xinit logs should be stored (default:/var/log/xwiki-health-check/xinit.log)" "/var/log/xwiki-health-check/xinit.log")
XWIKI_INSTALL_DIR=$(ask "Enter XWiki installation directory" "/usr/lib/xwiki-jetty/webapps/xwiki")

CHECK_HTTP=$(ask "Enable HTTP health checks (YES/no)" "yes")
EXPECT_HTTP_RESPONSE_CODE=$(ask "Expected HTTP response code from XWiki (e.g., 200, 302, 401)" "200")
CHECK_HTTP_URL=$(ask "Root URL of the instance (default: http://localhost:8080)" "http://localhost:8080")
echo "You can configure further the HTTP check in the xinit config file (/etc/xinit/xinit.cfg)"

PROCESS_CHECK=$(ask "Enable process check (YES/no)" "yes")

JETTY_HOME=$(ask "Enter Jetty home directory (default:/usr/lib/xwiki-jetty)" "/usr/lib/xwiki-jetty")
JETTY_BASE=$(ask "Enter Jetty base directory (default:same as home)" "/usr/lib/xwiki-jetty")
find_default_java_home() {
    local java_path
    java_path=$(readlink -f /usr/bin/java | sed "s:bin/java::")
    echo "$java_path"
}
DEFAULT_JAVA_HOME=$(find_default_java_home)
JAVA_HOME=$(ask "Enter Java home directory (default to system preferred)" "$DEFAULT_JAVA_HOME")
JETTY_USER=$(ask "Enter Jetty user (default: xwiki)" "xwiki")
XWIKI_OPTS=$(ask "Enter JVM options (e.g., -Xmx2048m)" "-Xmx2048m")
JETTY_PORT=$(ask "Enter Jetty HTTP port (default: 8080)" "8080")
JETTY_STOP_PORT=$(ask "Enter Jetty stop port (default:8079)" "8079")
JETTY_LOCK_FILE=$(ask "Enter Jetty lock file location" "${JETTY_BASE}/tmp/xwiki-${JETTY_PORT}.lck")

# Create /etc/xinit if it doesn't exist
if [ ! -d "/etc/xinit" ]; then
    mkdir /etc/xinit
    echo "${GREEN}Created /etc/xinit directory.${RESET}"
fi

# Backup existing xinit.cfg if it exists
if [ -f "/etc/xinit/xinit.cfg" ]; then
    cp /etc/xinit/xinit.cfg "/etc/xinit/xinit.cfg.$(date +%Y%m%d%H%M%S).bak"
    echo "${YELLOW}Existing xinit.cfg backed up.${RESET}"
fi

# Generate xinit.cfg
cat > /etc/xinit/xinit.cfg <<EOL
####################
# General Settings #
####################

# Mail Notification
#
# SEND_MAIL_NOTIFICATION: Set this parameter to "no" if you want to not send mail notifications.
# By default this feature is enabled.
SEND_MAIL_NOTIFICATION=${SEND_MAIL_NOTIFICATION}

# MAIL: Using this parameter you can specify one or more email
# addresses to which notifications will be sent. You can specify multiple email addresses
# by separating them with a comma (not space).
# Default value: empty
MAIL=${MAIL}

# SERVER_NAME: Use this parameter to set server name.
# If this parameter is not set the output of hostname command
# will be used.
# Default value: empty
#SERVER_NAME=""

# LOG_LINE_NUMBER: How many lines from cataline.out file you want to
# include in mail notification. By default the last 2000 lines will be
# included in mail notification.
LOG_LINE_NUMBER="${LOG_LINE_NUMBER}"

# LOG_FILE_LOCATION : Where the logs for Xinit should be located
# Default: /var/log/xwiki_health_check.log
LOG_FILE="${LOG_FILE}"

# CONNECTION_STATE_PORTS: You can use this parameter to specify the TCP ports
# for which you want to receive connection state information(ESTABLISHED,
# CLOSE_WAIT, CLOSE_WAIT ... etc). You can specify multiple ports separating
# them with space. The default value for this parameter is "8080 8009"
#CONNECTION_STATE_PORTS="8080 8009"

# LANG: Using this parameter you can set the locale name.
# By default it is set to "en_US.UTF-8"
#LANG="en_US.UTF-8"

# MYSQL_USER: Use this parameter to set a user which will be used to
# access mysql server. User must have privileges to list the full
# process list table and all databases.
# Default value: "root"
#MYSQL_USER="root"

# MYSQL_PASSWORD: Password to use when connecting to mysql server.
# Default value: empty
#MYSQL_PASSWORD=""

# MYSQL_HOST: Use this parameter to specify a host other then localhost.
# This host will be used to get mysql statistics and informations.
# Default value: "localhost"
#MYSQL_HOST="localhost"

# SPAM_THRESHOLD: This parameter is use to set a threshold for spam detection.
# All pages with an amount of comments >= this parameter will be considered as spammed.
#SPAM_THRESHOLD="50"

# DAEMONS_TO_MONITOR: Use this parameter to specify for which daemons
# you want to receive top informations. Separate them with space.
# Default value: "java mysqld apache2"
#DAEMONS_TO_MONITOR="java mysqld apache2"

# XWIKI_INSTALL_DIR: Use this parameter to specify the path where XWiki
# is installed.
# The "/usr/lib/xwiki-jetty/webapps/xwiki" folder is a symlink to "/usr/lib/jetty"
# Default value: "/usr/lib/xwiki-jetty/webapps/xwiki"
XWIKI_INSTALL_DIR=${XWIKI_INSTALL_DIR}

# KILL_QUIT_TIME_WAIT: Use this parameter to set how much time (in seconds)
# to wait after kill -QUIT command is executed.
# Default value: 4
#KILL_QUIT_TIME_WAIT="4"

# MAINTENANCE_ON_RESTARTS : Enable maintenance mode on any restart, including crashes.
# It will create $VAR_DIR/maintenance file (default /var/run/xinit/maintenance) if set to 1, during restarts.
# Default value: 1
#MAINTENANCE_ON_RESTARTS="1"

# MAINTENANCE_TIME : Parameter to set a maintenance time set after any restart
# that can occur. The wiki won't be restarted again during that amount of seconds.
# Default value: 600
#MAINTENANCE_TIME="600"

# MAINTENANCE_REMINDER : Send an email periodically to the emails in the MAIL parameter while maintenance mode is on
# You can change the interval at which the emails are sent using the MAINTENANCE_REMINDER_PERIOD variable below.
# Default value: 1
#MAINTENANCE_REMINDER="1"

# MAINTENANCE_REMINDER_PERIOD : Sets the period in which maintenance reminder emails are being sent. Only useful if
# MAITENANCE_REMINDER is enabled
# Default value: 3600
#MAINTENANCE_REMINDER_PERIOD="3600"

# CLEAN_TEMP_ON_STARTUP : Enable this if you want to remove everything in the Tomcat temp folder when starting up
# Default value: 1
#CLEAN_TEMP_ON_STARTUP="0"

# THREADDUMP_ANALYSIS_FILE : If THREADDUMP_ANALYSIS is enabled below, this file will store the
# Thread dump data sent to the webservice
# Default value: /var/tmp/xinit_thread_dump
#THREADDUMP_ANALYSIS_FILE="/var/tmp/xinit_thread_dump"

# THREADDUMP_ANALYSIS : Send the thread dump to a remote webservice for analysis and return the
# results inside the report. Set to empty if you want this feature disabled.
# Example value: "curl --data-binary @$THREADDUMP_ANALYSIS_FILE http://jthreader.xwiki.com/api/1/explain"
# Above example uses the XWikiSAS provided jthreader web serivce.
# Default value: ""
#THREADDUMP_ANALYSIS=""

#################
# First Request	#
#################
#
# MAKE_FIRST_REQUEST: After Tomcat is started you can choose to make
# the first request by setting this patrameter to "yes". HTTP Check will
# be used to make the first request.
# By default the first request is disabled.
#MAKE_FIRST_REQUEST="no"

####################
# OpenOffice Check #
####################

# OO_CHECK: Set this parameter to 1 if you want to check
# OpenOffice status or 0 instead. By default it is set to 1.
#OO_CHECK="1"

# OO_SERVER_TYPE: This parameter takes a value of 0 or 1
# 0 - Internally managed server instance. (Default)
# 1 - Externally managed (local) server instance.
# When OO server is internally managed it will only be checked
# when tomcat is stopped/restarted and it will be killed if it is
# still running after tomcat is stopped.
#OO_SERVER_TYPE="0"

# OO_SERVER_PORT: This parameter specify on which port should
# OpenOffice daemon run. Default is 8100
#OO_SERVER_PORT="8100"

# OO_DAEMON_PATH: This parameter specifies the path to OO daemon.
# Default is: /opt/openoffice.org3/program/soffice.bin
#OO_DAEMON_PATH="/opt/openoffice.org3/program/soffice.bin"

################
# HTTP Check   #
################

# CHECK_HTTP: This parameter is used to enable/disable http check function.
# Set this parameter to "yes" is you want to enable http check function.
# By default http check function is disabled.
CHECK_HTTP=${CHECK_HTTP}

# EXPECT_HTTP_RESPONSE_CODE: Use this parameter to specify a http respons code. This
# code is used to determine if the wiki is available or not. Some useful http codes are:
# 200 OK
# 400 Bad Request
# 401 Unauthorized
# 403 Forbidden
# 404 Not Found
# 405 Method Not Allowed
# 500 Internal Server Error
# Typically any of these codes may means that the wiki is responding. For example if
# xinit is trying to access a page that for which it need to login to the wiki it will
# receive an 401 code. But that means it was able to access that page in an amount of time
# and it can say that the wiki is available. Xinit will receive code 200 when the page is
# trying to access is public.
# You can use any of the HTTP/1.1 response code protocol.
# Default value: 200
EXPECT_HTTP_RESPONSE_CODE=${EXPECT_HTTP_RESPONSE_CODE}

# USE_DNS: This parameter is used to specify if xinit will take into account if the
# domain name used to check the wiki was resolve or not. If set to "yes" xinit will NOT
# restart the wiki in case it was not able to resolve the domain name but a mail will be sent
# to the addresses specified by MAIL parameter. Set this parameter to "no" in case you
# don't want enable this feature.
# Default value: yes
#USE_DNS="yes"

# CHECK_HTTP_URL: Use this parameter to pecify the address of the wiki you want to check.
# You can use an IP or a domain name and you can also specify a different port to connect to.
# The format is: http://domain or http://domain:8080 or use and IP.
# If ca use https instead of http.
# Default value: empty
CHECK_HTTP_URL=${CHECK_HTTP_URL}

# USE_BASIC_AUTH: Set this parameter to "yes" if you want to enable basic authentication.
# Default value: "no"
#USE_BASIC_AUTH="no"

# These parameters are used in case the wiki is protected
# with an htaccess file. In this case a username and password
# are needed to check the wiki availability.
#HTACCESS_USERNAME="username"
#HTACCESS_PASSWORD="password"

# Http time parameters in sec.
CHECK_HTTP_TIMEOUT=50
CHECK_HTTP_TRIES=2
CHECK_HTTP_WAITRETRY=10

#################
# Process Check #
#################

# PROCESS_CHECK: This function is enabled by default
# and can be disabled by setting this parameter to "no".
PROCESS_CHECK=${PROCESS_CHECK}

# JVM & Jetty Settings
NAME=Jetty

# Jetty home directory
JETTY_HOME=${JETTY_HOME}

# Jetty base directory (if separate from home)
JETTY_BASE=${JETTY_BASE}

# Java home directory
JAVA_HOME=${JAVA_HOME}

# Jetty user
JETTY_USER=${JETTY_USER}

# JVM options
XWIKI_OPTS=${XWIKI_OPTS}

# Jetty options (additional options if needed)
JETTY_OPTS=

# Jetty HTTP port
JETTY_PORT=${JETTY_PORT}

# Jetty stop port
JETTY_STOP_PORT=${JETTY_STOP_PORT}

# Jetty lock file
LCK=${JETTY_LOCK_FILE}
EOL

echo "${GREEN}Configuration file /etc/xinit/xinit.cfg created.${RESET}"

# CHECK LOG FOLDERS AND SET PERMISSIONS
echo ""
echo "${BOLD}Checking logs configuration...${RESET}"

XWIKI_LOG_DIR="/var/log/xwiki" # NOTE : that assumes there is a link between the JETTY_BASE/logs and the /var/log/xwiki folder

if [ ! -d "$XWIKI_LOG_DIR" ]; then
    mkdir -p "$XWIKI_LOG_DIR"
    echo "${GREEN}Created directory $XWIKI_LOG_DIR.${RESET}"
else
    echo "${YELLOW}Directory $XWIKI_LOG_DIR already exists.${RESET}"
fi

chown -R ${JETTY_USER}:${JETTY_USER} "$XWIKI_LOG_DIR"
chmod 750 "$XWIKI_LOG_DIR"
echo "${GREEN}Set permissions for $XWIKI_LOG_DIR (owner: ${JETTY_USER}).${RESET}"

if [ -f /etc/xinit/xinit.cfg ]; then
    source /etc/xinit/xinit.cfg
    if [ -n "$LOG_FILE" ]; then
        CUSTOM_LOG_DIR=$(dirname "$LOG_FILE")
        if [ ! -d "$CUSTOM_LOG_DIR" ]; then
            mkdir -p "$CUSTOM_LOG_DIR"
            echo "${GREEN}Created custom log directory $CUSTOM_LOG_DIR.${RESET}"
        else
            echo "${YELLOW}Custom log directory $CUSTOM_LOG_DIR already exists.${RESET}"
        fi
        chown -R ${JETTY_USER}:${JETTY_USER} "$CUSTOM_LOG_DIR"
        chmod 750 "$CUSTOM_LOG_DIR"
        echo "${GREEN}Set permissions for $CUSTOM_LOG_DIR (owner: ${JETTY_USER}).${RESET}"
    else
        echo "${YELLOW}LOG_FILE is not set in /etc/xinit/xinit.cfg. Skipping creation of custom log directory.${RESET}"
    fi
else
    echo "${RED}ERROR: /etc/xinit/xinit.cfg not found.${RESET}"
fi

# SETUP LOGROTATE
echo ""
echo "${BOLD}Installing logrotate configuration...${RESET}"
if cp "${SCRIPT_DIR}/etc/logrotate.d/xinit" /etc/logrotate.d/xwiki; then
    echo "${GREEN}Logrotate configuration installed at /etc/logrotate.d/xinit.${RESET}"
else
    echo "${RED}Failed to install logrotate configuration.${RESET}"
fi

# SETUP SYSTEMD
echo ""
echo "${BOLD}Installing systemd service and timer files...${RESET}"
if cp "${SCRIPT_DIR}/etc/systemd/"*.service /etc/systemd/system/ && cp "${SCRIPT_DIR}/etc/systemd/"*.timer /etc/systemd/system/; then
    echo "${GREEN}Systemd files installed in /etc/systemd/system/.${RESET}"
    systemctl daemon-reload
    echo "${GREEN}Systemd daemon reloaded.${RESET}"
else
    echo "${RED}Failed to install systemd files.${RESET}"
fi

# SETUP XWIKI.SERVICE
echo ""
echo "${BOLD}Enabling and starting xwiki.service...${RESET}"
if systemctl enable xwiki.service && systemctl restart xwiki.service; then
    echo "${GREEN}XWiki service enabled and started.${RESET}"
else
    echo "${RED}Failed to enable/start xwiki.service.${RESET}"
fi

# SETUP HEALTHCHECK
echo ""
echo "${BOLD}Enabling and starting xwiki-healthcheck.timer...${RESET}"
if systemctl enable xwiki-healthcheck.timer && systemctl start xwiki-healthcheck.timer; then
    echo "${GREEN}XWiki healthcheck timer enabled and started.${RESET}"
else
    echo "${RED}Failed to enable/start xwiki-healthcheck.timer.${RESET}"
fi

# SETUP MAINTENANCE
echo ""
echo "${BOLD}Enabling and starting xwiki-maintenance-reminder.timer...${RESET}"
if systemctl enable xwiki-maintenance-reminder.timer && systemctl start xwiki-maintenance-reminder.timer; then
    echo "${GREEN}XWiki maintenance reminder timer enabled and started.${RESET}"
else
    echo "${RED}Failed to enable/start xwiki-maintenance-reminder.timer.${RESET}"
fi

# SETUP LOCALBIN
echo ""
echo "${BOLD}Installing scripts to /usr/local/bin/...${RESET}"
if cp "${SCRIPT_DIR}/usr/local/bin/"* /usr/local/bin/; then
    chmod +x /usr/local/bin/*
    echo "${GREEN}Scripts installed in /usr/local/bin/ and made executable.${RESET}"
else
    echo "${RED}Failed to install scripts to /usr/local/bin/.${RESET}"
fi

# ENFORCE STRICT PERMISSIONS
echo ""
echo "${BOLD}Setting permissions...${RESET}"
if chown root:root /usr/local/bin/* && chmod 755 /usr/local/bin/*; then
    echo "${GREEN}Ownership and permissions set for scripts in /usr/local/bin/.${RESET}"
else
    echo "${RED}Failed to set permissions for scripts.${RESET}"
fi

# Et voilà
echo ""
echo "${BOLD}${GREEN}=================================================${RESET}"
echo "${BOLD}${GREEN}          XWiki Management Installation          ${RESET}"
echo "${BOLD}${GREEN}                   Complete!                     ${RESET}"
echo "${BOLD}${GREEN}=================================================${RESET}"
echo ""
echo "${BOLD}${GREEN}         Don't forget to check xinit.cfg         ${RESET}"
echo "${BOLD}${GREEN}            For Further customisation            ${RESET}"
echo ""
echo "You can manage XWiki using the '${BOLD}xwiki${RESET}' command."
echo "For help, run '${BOLD}xwiki help${RESET}'."
echo ""

exit 0