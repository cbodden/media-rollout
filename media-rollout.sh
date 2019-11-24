#!/usr/bin/env bash

#===============================================================================
#          FILE: media_rollout.sh
#         USAGE: ./media_rollout.sh
#   DESCRIPTION: This script rolls out and configures a default for  :
#                SABnzbd, NZBHydra2, Lidarr, Sonarr, Radarr, and
#                LazyLibrarian
#       OPTIONS: none yet
#  REQUIREMENTS: fresh ubuntu 18.04 install
#          BUGS: untested
#         NOTES: this will be updated decently often
#        AUTHOR: cesar@pissedoffadmins.com
#  ORGANIZATION: pissedoffadmins.com
#       CREATED: 11/23/2019
#      REVISION: 3
#===============================================================================
##########################################
#### EDITS ONLY IN THIS SECTION BELOW ####
##########################################

## this is for the paths that will be used
## as permanent storage for all the media
## if not set it will use "/storage" by default
## this will expand to:
## /storage/books, /storage/downloads, /storage/movies,
## /storage/music, /storage/tv, /storage/downloads/complete,
## and /storage/downloads/incomplete
## leave off leading and trailing slashes
#  change main path here:
_MEDIA_PATH=""

## this setting is for the ip address that will be assigned to
## all the services installed.
## this can not be set to: 127.0.0.1 or 0.0.0.0
## if left blank the systems ip address will be used
#  change ip here:
_MEDIA_IP=""

## this setting is for the username for all the services.
## by default all the usernames will be set to "admin"
## unless changed below
_CONFIG_UNAME=""

## this setting is for the password for all the services.
## by default all the passwords will be set to "admin"
## unless changed below
_CONFIG_PWORD=""

##################################################
#### END OF EDITs SECTION - DO NOT EDIT BELOW ####
##################################################

function main()
{
    LC_ALL=C
    LANG=C

    readonly RED=$(tput setaf 1)
    readonly BLU=$(tput setaf 4)
    readonly GRN=$(tput setaf 40)
    readonly CLR=$(tput sgr0)

    ## check for sudo
    local _R_UID="0"
    if [ "${UID}" -ne "${_R_UID}" ]
    then
        printf "%s\n" \
            "${RED}. . .Needs sudo. . .${CLR}"

        exit 1
    fi

    # if $SHELL == /bin/bash have some default sets
    case "$(echo $SHELL 2>/dev/null)" in
        '/bin/bash')
            # set -o nounset
            set -o pipefail
            set -e
            set -u
            ;;
    esac

    trap 'echo "${NAME}: Ouch! Quitting." 1>&2 ; exit 1' 1 2 3 9 15

    readonly _IP=${_MEDIA_IP:-$(awk '{print $1}' <(hostname -I))}
    readonly _PATH=${_MEDIA_PATH:-storage}

    readonly _UNAME=${_CONFIG_UNAME:-admin}
    readonly _PWORD=${_CONFIG_PWORD:-admin}

    readonly _API_GEN="$(head /dev/urandom \
        | tr -dc a-f0-9 \
        | head -c 32 )"

    readonly _GIT_PATH="https://github.com/cbodden/media-rollout/blob/master"
    readonly _SAB_HOME="/home/sabnzbd/.sabnzbd"
}

function _pause()
{
    printf "%s\n" \
        "${GRN}. . . .Press enter to continue. . . .${CLR}"

    read -p "$*"
}

function _USERS_GROUPS()
{
    getent group downloads ||  groupadd downloads

    local _USERS="sabnzbd hydra lidarr sonarr radarr lazylibrarian"
    for ITER in ${_USERS}
    do
        addgroup ${ITER}
        adduser --system ${ITER} --ingroup ${ITER}
        usermod -a -G downloads ${ITER}
    done

    local _DRV="books downloads/complete downloads/incomplete movies music tv"
    for ITER in ${_DRV}
    do
        mkdir -p /${_PATH}/${ITER}
    done
}

function _APT_WORK()
{
    add-apt-repository multiverse
    add-apt-repository universe
    add-apt-repository ppa:jcfp/nobetas
    add-apt-repository ppa:jcfp/sab-addons
    apt update -y
    apt-get dist-upgrade -y

    apt install \
        apt-transport-https \
        curl \
        git-core \
        gnupg ca-certificates \
        libchromaprint-tools \
        mediainfo \
        openjdk-11-jre-headless \
        sqlite3 \
        software-properties-common \
        unzip \
        -y

    apt-key adv \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

    apt-key adv \
        --keyserver keyserver.ubuntu.com \
        --recv-keys 0xA236C58F409091A18ACA53CBEBFF6B99D9B78493

    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main"\
        |  tee /etc/apt/sources.list.d/mono-official-stable.list

    echo "deb http://download.mono-project.com/repo/debian jessie main" \
        |  tee /etc/apt/sources.list.d/mono-xamarin.list

    echo "deb http://apt.sonarr.tv/ master main" \
        |  tee /etc/apt/sources.list.d/sonarr.list

    apt update -y
    apt install mono-devel -y
}

function _sabnzbd()
{
    apt install \
        sabnzbdplus \
        python-sabyenc \
        par2-tbb \
        -y

    systemctl daemon-reload
    systemctl enable sabnzbdplus.service
    chown -R sabnzbd:downloads /${_PATH}/downloads/*
}

function _sabnzbd_configure()
{
    mkdir -p ${_SAB_HOME}
    wget ${_GIT_PATH}/config_files/sabnzbd.ini -O ${_SAB_HOME}/sabnzbd.ini

    sed -i "s|^api_key =.*|api_key = ${_API_GEN}|g" ${_SAB_HOME}/sabnzbd.ini
    sed -i "s|^host =.*|host = ${_IP}|g" ${_SAB_HOME}/sabnzbd.ini
    sed -i "s|^download_dir =.*|download_dir = ${_PATH}/download/incomplete|g" ${_SAB_HOME}/sabnzbd.ini
    sed -i "s|^nzb_key =.*|nzb_key = ${_API_GEN}|g" ${_SAB_HOME}/sabnzbd.ini
    sed -i "s|^complete_dir =.*|complete_dir = ${_PATH}/download/complete|g" ${_SAB_HOME}/sabnzbd.ini
    sed -i "s|^username =.*|username = ${_UNAME}|g" ${_SAB_HOME}/sabnzbd.ini
    sed -i "s|^password =.*|password = ${_PWORD}|g" ${_SAB_HOME}/sabnzbd.ini
    sed -i "s|^host_whitelist =.*|host_whitelist = $(hostname),|g" ${_SAB_HOME}/sabnzbd.ini
}

function _nzbhydra2()
{
    mkdir /opt/nzbhydra2
    cd /opt/nzbhydra2

    local _NH_ADDY="https://github.com/theotherp/nzbhydra2/releases"

    local _NH_VER="$(curl -s ${_NH_ADDY}/latest \
        | cut -d\" -f2 \
        | awk -F 'tag/' '{print $2}' )"

    local _NH_TAG="${_NH_ADDY}/tag/${_NH_VER}"

    local _NH_RLS="$(curl -s ${_NH_ADDY}/tag/${_NH_VER} \
        | grep linux \
        | head -n 1 \
        | cut -d\" -f2 \
        | awk -F "${_NH_VER}/" '{print $2}' )"

    wget ${_NH_ADDY}/download/${_NH_VER}/${_NH_RLS} -O /opt/nzbhydra2/${_NH_RLS}

    unzip ${_NH_RLS}
    rm ${_NH_RLS}

    cp systemd/nzbhydra2.service /lib/systemd/system/nzbhydra2.service

    sed -i 's/User=ubuntu.*/User=hydra/' /lib/systemd/system/nzbhydra2.service
    sed -i 's/Group=vboxsf.*/Group=hydra/' /lib/systemd/system/nzbhydra2.service
    sed -i 's/ExecStart=\/home\/nzbhydra\/nzbhydra2\/nzbhydra2 --nobrowser.*/ExecStart=\/usr\/bin\/python \/opt\/nzbhydra2\/nzbhydra2wrapper.py --nobrowser --datafolder \/home\/hydra\/.nzbhydra2_data/' /lib/systemd/system/nzbhydra2.service

    chown -R hydra:hydra /opt/nzbhydra2/
    systemctl daemon-reload
    systemctl enable nzbhydra2.service
}

function _lidarr()
{
    cd /opt/

    _LR_ADDY="https://github.com/lidarr/Lidarr/releases"

    _LR_RLS_PATH="$(curl -s ${_LR_ADDY} \
        | grep "linux.tar.gz" \
        | head -n 1 \
        | cut -d\" -f2 )"

    _LR_DLD_PATH="$(echo ${_LR_RLS_PATH} \
        | cut -d'/' -f6-7 )"

    wget ${_LR_ADDY}/download/${_LR_DLD_PATH}

    tar -xzvf ${_LR_DLD_PATH##*/}
    chown -R lidarr:lidarr /opt/Lidarr/

    cat <<-EOF >/etc/systemd/system/lidarr.service
    [Unit]
    Description=Lidarr Daemon
    After=syslog.target network.target

    [Service]
    User=lidarr
    Group=lidarr
    Type=simple
    ExecStart=/usr/bin/mono /opt/Lidarr/Lidarr.exe -nobrowser
    TimeoutStopSec=20
    KillMode=process
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target
EOF

    chown -R lidarr:downloads /${_PATH}/music
    systemctl daemon-reload
    systemctl enable lidarr.service
}

function _sonarr()
{
    apt install nzbdrone
    chown -R sonarr:sonarr /opt/NzbDrone/

    cat <<- EOF >/lib/systemd/system/sonarr.service
    [Unit]
    Description=Sonarr Daemon
    After=network.target

    [Service]
    User=sonarr
    Group=sonarr

    Type=simple
    ExecStart=/usr/bin/mono /opt/NzbDrone/NzbDrone.exe -nobrowser
    TimeoutStopSec=20
    KillMode=process
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target
EOF

    chown -R sonarr:downloads /${_PATH}/tv
    systemctl daemon-reload
    systemctl enable sonarr.service
}

function _radarr()
{
    cd /opt/

    _RD_ADDY="https://github.com/Radarr/Radarr/releases"

    _RD_RLS_PATH="$(curl -s ${_RD_ADDY} \
        | grep "linux.tar.gz" \
        | head -n 1 \
        | cut -d\" -f2 )"

    _RD_DLD_PATH="$(echo ${_RD_RLS_PATH} \
        | cut -d'/' -f6-7 )"

    wget ${_RD_ADDY}/download/${_RD_DLD_PATH}

    tar -xzvf ${_RD_DLD_PATH##*/}
    chown -R radarr:radarr /opt/Radarr

    cat <<- EOF >/lib/systemd/system/radarr.service
    [Unit]
    Description=Radarr Daemon
    After=syslog.target network.target

    [Service]
    User=radarr
    Group=radarr
    Type=simple
    ExecStart=/usr/bin/mono /opt/Radarr/Radarr.exe -nobrowser
    TimeoutStopSec=20
    KillMode=process
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target
EOF

    chown -R radarr:downloads /${_PATH}/movies
    systemctl daemon-reload
    systemctl enable radarr.service
}

function _lazylibrarian()
{
    cd /opt/
    git clone https://github.com/DobyTang/LazyLibrarian.git
    chown -R lazylibrarian:lazylibrarian /opt/LazyLibrarian/
    cp LazyLibrarian/init/lazylibrarian.default /etc/default/lazylibrarian
    sed -i 's/RUN_AS=$USER.*/RUN_AS=lazylibrarian/' /etc/default/lazylibrarian
    cp LazyLibrarian/init/lazylibrarian.initd /etc/init.d/lazylibrarian

    chown -R lazylibrarian:downloads /${_PATH}/books
    chmod a+x /etc/init.d/lazylibrarian
    update-rc.d lazylibrarian defaults
}


main
_USERS_GROUPS
_APT_WORK
_sabnzbd
_nzbhydra2
_lidarr
_sonarr
_radarr
_lazylibrarian
