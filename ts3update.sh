#!/usr/bin/env bash

VERSION_FILE="version.txt"
CURRENT_VERISON="$(cat $VERSION_FILE)"
USER="ts3"

function getLatestTS3Version() {
        TS3_SERVER_VERSION="";
        if [[ -z "${TS3_SERVER_VERSION}" ]]; then
                wget -t 1 -T 3 'https://files.teamspeak-services.com/releases/server/' -q -O - | grep -Ei 'a href="[0-9]+' | grep -Eo ">(.*)<" | tr -d ">" | tr -d "<" | uniq | sort -V -r > RELEASES.txt

                if [[ $? -ne 0 ]]; then
                        return 1;
                fi

                while read release; do
                        wget -t 1 -T 1 --spider -q "https://files.teamspeak-services.com/releases/server/${release}/teamspeak3-server_linux_amd64-${release}.tar.bz2"

                        if [[ $? == 0 ]]; then
                                TS3_SERVER_VERSION="$release"
                                break
                        fi
                done < RELEASES.txt

                rm RELEASES.txt
        fi

        if [[ -n "$TS3_SERVER_VERSION" ]]; then
                echo -n "$TS3_SERVER_VERSION";
        else
                return 1;
        fi
}

TS3_SERVER_VERSION="$(getLatestTS3Version)";

if [[ -n "$TS3_SERVER_VERSION" ]] && [[ "$TS3_SERVER_VERSION" != "0" ]]; then
        echo "latest Version: $TS3_SERVER_VERSION";

        if [ "$TS3_SERVER_VERSION" == "$CURRENT_VERISON" ] ;then
                echo "No Update: current version $CURRENT_VERISON"
        else
                echo "Update $CURRENT_VERISON => $TS3_SERVER_VERSION"
                wget -O ts3.tar.bz2 "https://files.teamspeak-services.com/releases/server/${TS3_SERVER_VERSION}/teamspeak3-server_linux_amd64-${TS3_SERVER_VERSION}.tar.bz2"
                if [ $? -eq 0 ]; then
                        echo "Stop TS3"

                        /etc/init.d/teamspeak stop
                        echo "Unpack"
                        tar -xjf ts3.tar.bz2 --owner=$USER

                        echo "Start TS3"
                        /etc/init.d/teamspeak start

                        echo "$TS3_SERVER_VERSION" > $VERSION_FILE

						rm ts3.tar.bz2
                else
                        echo "Downlod failed. Please check version"
                fi
        fi

else
        return "Can not detect Version";
fi
