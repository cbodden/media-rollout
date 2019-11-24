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
#        AUTHOR: Cesar Bodden (), cesar@pissedoffadmins.com
#  ORGANIZATION: pissedoffadmins.com
#       CREATED: 11/23/2019 03:40:08 PM EST
#      REVISION: 1
#===============================================================================

set -o nounset

mkdir -p \
    /storage/books \
    /storage/downloads \
    /storage/movies \
    /storage/music \
    /storage/tv \
    /storage/downloads/complete \
    /storage/downloads/incomplete

getent group downloads || sudo groupadd downloads

_USERS="sabnzbd hydra lidarr sonarr radarr lazylibrarian"
for ITER in ${_USERS}
do
    addgroup ${ITER}
    adduser --system ${ITER} --ingroup ${ITER}
    usermod -a -G downloads ${ITER}
done

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
    libchromat-tools \
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
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" \
    | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
echo "deb http://download.mono-project.com/repo/debian jessie main" \
    | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
echo "deb http://apt.sonarr.tv/ master main" \
    | sudo tee /etc/apt/sources.list.d/sonarr.list

apt update -y
apt install mono-devel -y


#### sabnzbd ####

apt install sabnzbdplus python-sabyenc par2-tbb
systemctl daemon-reload
systemctl start sabnzbdplus.service


#### nzbhydra2 ####

mkdir /opt/nzbhydra2
cd /opt/nzbhydra2

## nzbhydra version and latest file
#  releases addy
_NH_ADDY="https://github.com/theotherp/nzbhydra2/releases"
#  get the version number
_NH_VER="$(curl -s ${_NH_ADDY}/latest \
    | cut -d\" -f2 \
    | awk -F 'tag/' '{print $2}' )"
#  tag addy
_NH_TAG="https://github.com/theotherp/nzbhydra2/releases/tag/${_NH_VER}"
#  get the tagged release name
_NH_RLS="$(curl -s ${_NH_ADDY}/tag/${_NH_VER} \
    | grep linux \
    | head -n 1 \
    | cut -d\" -f2 \
    | awk -F "${_NH_VER}/" '{print $2}' )"
#  download the tagged release to /opt
wget ${_NH_ADDY}/download/${_NH_VER}/${_NH_RLS} -O /opt/${_NH_RLS}

unzip ${_NH_RLS}
rm ${_NH_RLS}

sudo chown -R hydra:hydra /opt/nzbhydra2/

systemctl daemon-reload
systemctl enable nzbhydra2.service


#### lidarr ####

cd /opt/

## lidarr version and latest file (pre-release, this code will change)
#  releases addy
_LR_ADDY="https://github.com/lidarr/Lidarr/releases"
#  release path
_LR_RLS_PATH="$(curl -s ${_LR_ADDY} \
    | grep "linux.tar.gz" \
    | head -n 1 \
    | cut -d\" -f2 )"
#  get the download path
_LR_DLD_PATH="$(echo ${_LR_RLS_PATH} \
    | cut -d'/' -f6-7 )"
#  download the release to /opt
wget ${_LR_ADDY}/download/${_LR_DLD_PATH}

tar -xzvf ${_LR_DLD_PATH##*/}
sudo chown -R lidarr:lidarr /opt/Lidarr/

systemctl daemon-reload
systemctl enable lidarr.service


#### sonarr ####

apt install nzbdrone
chown -R sonarr:sonarr /opt/NzbDrone/

systemctl daemon-reload
systemctl enable sonarr.service


#### radarr ####

cd /opt/

## radarr version and latest file (pre-release, this code will change)
#  releases addy
_RD_ADDY="https://github.com/Radarr/Radarr/releases"
#  release path
_RD_RLS_PATH="$(curl -s ${_RD_ADDY} \
    | grep "linux.tar.gz" \
    | head -n 1 \
    | cut -d\" -f2 )"
#  get the download path
_RD_DLD_PATH="$(echo ${_RD_RLS_PATH} \
    | cut -d'/' -f6-7 )"
#  download the release to /opt
wget ${_RD_ADDY}/download/${_RD_DLD_PATH}

tar -xzvf ${_RD_DLD_PATH##*/}
sudo chown -R radarr:radarr /opt/Radarr

sudo systemctl daemon-reload
sudo systemctl enable radarr.service


#### lazylibrarian ####

cd /opt/
sudo git clone https://github.com/DobyTang/LazyLibrarian.git
sudo chown -R lazylibrarian:lazylibrarian /opt/LazyLibrarian/
