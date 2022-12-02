# Teamspeak Setup + Scripts
Setup and Scripts to run teamspeak with SQL Database, start automatically on server start and autoupdate

# Requirements
teamspeak install under `/usr/local/ts3`

dedicated user `ts3`

# Install Scripts

copy init script to `/etc/init.d/teamspeak`

for teamspeak running with sql database use example ini

add cron symlink to ts3update.sh in `/etc/cron.weekly/`
