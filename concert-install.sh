#!/bin/bash
# Install IBM Concert 
# v1.0.0 (27/02/2025)
# update the variables below or be prompted
# requires an IBM Entitlement Key

#variables
isDocker=false
isPodman=false
DOCKER_EXE=
CONCERT_REGISTRY=cp.icr.io/cp/concert
CONCERT_REGISTRY_USER=cp
# This is the entitlement key
CONCERT_REGISTRY_PASSWORD=
CONCERT_USERID=ibmconcert
CONCERT_PASSWORD=

function getDate() {
	echo "[`date "+%Y-%m-%d %H:%M:%S"`] "
}

function check_status() {
	if [ $1 -ne 0 ]; then
		echo "failed."
		exit 1
	else
		echo "pass."
	fi
}

# Print the documentation link
echo "---"
echo "Documentation with requirements : https://www.ibm.com/docs/en/concert?topic=vm-installing-concert-software"
echo 
echo "IBM Entitlement Key : https://myibm.ibm.com/products-services/containerlibrary"
echo "---"

# check whether this is RHEL and display a message that lingering needs to be enabled
if [ -f /etc/redhat-release ]; then
    if [ -d /var/lib/systemd/linger ]; then
        if [ `ls /var/lib/systemd/linger | grep $USER  | wc -l` -eq 0 ]; then
            echo $(getDate) "For RHEL systems, enable lingering : loginctl enable-linger $USER"
            exit 1
        fi 
    else
        echo $(getDate) "Missing /var/lib/systemd/linger file for lingering on RHEL"
        exit 1
    fi
fi

# Check whether the necessary software is available on the system
echo -n $(getDate)  "Checking whether curl is installed ... "
which curl >/dev/null 2>&1
check_status $?

echo -n $(getDate)  "Checking whether wget is installed ... "
which wget >/dev/null 2>&1
check_status $?

echo -n $(getDate)  "Checking whether jq is installed ... "
which jq >/dev/null 2>&1
check_status $?

echo -n $(getDate)  "Checking whether tar is installed ... "
which tar >/dev/null 2>&1
check_status $?

echo -n $(getDate)  "Checking whether docker or podman is installed ... "
which docker >/dev/null 2>&1
if [ $? -eq 0 ]; then
    isDocker=true
    echo "pass."
else
    which podman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        isPodman=true
        echo "pass."
    else
        echo "fail."
        exit 1
    fi
fi

if [ $isDocker = "true" ]; then
   DOCKER_EXE="docker"
fi

if [ $isPodman = "true" ]; then
    DOCKER_EXE="podman"
fi

# get the latest version from github
echo -n  $(getDate) "Retrieving the current version ... "
LATEST_TAG=$(curl --silent https://api.github.com/repos/IBM/Concert/releases/latest | jq -r .tag_name)
check_status $?

# Download the lastest version of the software installer
echo -n  $(getDate) "Downloading the current version ... "
wget https://github.com/IBM/Concert/releases/download/${LATEST_TAG}/ibm-concert-std.tgz
check_status $?

# unpack the file 
echo -n  $(getDate) "Expand the download file ... "
tar -xf ibm-concert-std.tgz
check_status $?

# Check the entitlement key
if [ -z $CONCERT_REGISTRY_PASSWORD ]; then
    echo "Obtain your IBM Entitlement Key from : https://myibm.ibm.com/products-services/containerlibrary"
    echo ""
	while true; do
        	read -p "IBM Entitlement Key: " CONCERT_REGISTRY_PASSWORD
        	if [ ${#CONCERT_REGISTRY_PASSWORD} -ne 0 ]; then
                	break
        	fi
	done
fi

# Login to the concert  registry
echo -n  $(getDate) "Logon to the Concert registry ... "
$DOCKER_EXE login $CONCERT_REGISTRY --username=$CONCERT_REGISTRY_USER --password=$CONCERT_REGISTRY_PASSWORD
check_status $?

# check if a password was provided for concert userid
if [ -z $CONCERT_PASSWORD ]; then
	while true; do
        	read -p "Enter a password for the concert userid : " CONCERT_PASSWORD
        	if [ ${#CONCERT_PASSWORD} -ne 0 ]; then
                	break
        	fi
	done
fi

# Install and start concert
echo  $(getDate) "Setting up Concert ... "
ibm-concert-std/bin/setup --license_acceptance=y --registry=${CONCERT_REGISTRY} --runtime=${DOCKER_EXE} --username=${CONCERT_USERID} --password=${CONCERT_PASSWORD}
check_status $?

echo $(getDate) "Finish!"