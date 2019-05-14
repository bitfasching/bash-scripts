#!/bin/bash
# nick@bitfasching.de, 2015
# To be scheduled with root's crontab.

# define log file and timestamp
LOGFILE=/root/apt-daily-update.log
DATE=$(date +"%Y-%m-%d %H:%M:%S %z")

# to get apt-get -y without prompts
DEBIAN_FRONTEND=noninteractive

echo "-------------------------------------------" >> $LOGFILE
echo "APT Daily Update: $DATE" >> $LOGFILE

# housekeeping: remove old downloaded archives
# (-qq: only output errors, 2>&1: redirect stderr to stdout)
apt-get -qq autoclean 2>&1 | tee --append $LOGFILE

# fetch package lists
apt-get -qq update 2>&1 | tee --append $LOGFILE

# upgrade packages
# (-q: loggable output, -y: confirm any prompt)
# (1>/dev/null: discard stdout, let stderr through)
apt-get -q -y upgrade | tee --append $LOGFILE 1>/dev/null

# If run via crontab, uncaught messages on stderr should be delivered to root's mail.
