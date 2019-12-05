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
#      REVISION: 4
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

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))

## source all the shlib's
source shlib/apt.shlib
source shlib/finish.shlib
source shlib/lazylibrarian.shlib
source shlib/lidarr.shlib
source shlib/main.shlib
source shlib/nzbhydra2.shlib
source shlib/pause.shlib
source shlib/plex.shlib
source shlib/radarr.shlib
source shlib/sabnzbd.shlib
source shlib/sonarr.shlib
source shlib/storage.shlib
source shlib/tautulli.shlib
source shlib/usage.shlib

## option selection
while getopts "chik:r" OPT
do
    case "${OPT}" in
        'c')
            main
            _sabnzbdplus_configure
            _nzbhydra2_configure
            _lidarr_configure
            _radarr_configure
            _sonarr_configure
            _finish_configure
            exit 0
            ;;
        'h')
            _usage
            exit 0
            ;;
        'i')
            main
            _storage
            _apt
            _sabnzbdplus_install
            _nzbhydra2_install
            _lidarr_install
            _sonarr_install
            _radarr_install
            _lazylibrarian_install
            _plexmediaserver_install
            _tautulli_install
            _finish
            _clean
            exit 0
            ;;
        'k')
            pass an arg to ${OPTARG}
            ;;
        'r')
            main
            _lazylibrarian_remove
            _lidarr_remove
            _nzbhydra2_remove
            _plexmediaserver_remove
            _radarr_remove
            _sabnzbdplus_remove
            _sonarr_remove
            _tautulli_remove
            exit 0
            ;;
        *)
            _usage
            exit 0
            ;;
    esac
done
if [[ ${OPTIND} -eq 1 ]]
then
    _usage
    exit 0
fi
