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
source shlib/bazarr.shlib
source shlib/finish.shlib
source shlib/info.shlib
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

declare -a _Install=($(declare -F \
    | awk '/_install/ {print $3}' \
    | grep -v finish))

declare -a _Configure=($(declare -F \
    | awk '/_configure/ {print $3}' \
    | grep -v finish))

declare -a _Remove=($(declare -F \
    | awk '/_remove/ {print $3}' \
    | grep -v finish))

## option selection
while getopts "cChHiIrR" OPT
do
    case "${OPT}" in
        'c'|'C')
            main
            _sabnzbdplus_configure
            _nzbhydra2_configure
            _lidarr_configure
            _radarr_configure
            _sonarr_configure
            _finish_configure
            exit 0
            ;;
        'h'|'H')
            _usage
            exit 0
            ;;
        'i'|'I')
            main
            _storage
            _apt
            if [[ ${#_Install[*]} -gt 1 ]]
            then
                for ITER in "${_Install[@]}"
                do
                    ${ITER}
                done
            fi
            _finish
            _clean
            exit 0
            ;;
        'r'|'R')
            main
            if [[ ${#_Remove[*]} -gt 1 ]]
            then
                for ITER in "${_Remove[@]}"
                do
                    ${ITER}
                done
            fi
            exit 0
            ;;
        *)
            _usage
            _info
            exit 0
            ;;
    esac
done
if [[ ${OPTIND} -eq 1 ]]
then
    _usage
    _info
    exit 0
fi
