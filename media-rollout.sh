#!/usr/bin/env bash

#===============================================================================
#          FILE: media_rollout.sh
#         USAGE: ./media_rollout.sh
#   DESCRIPTION: This script rolls out a media stack
#                Check help for description
#       OPTIONS: Check help
#  REQUIREMENTS: fresh ubuntu 18.04 install
#          BUGS: probably a bunch
#        AUTHOR: cesar@pissedoffadmins.com
#  ORGANIZATION: pissedoffadmins.com
#       CREATED: 11/23/2019
#===============================================================================

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))

## source all the shlib's
for ITER in shlib/*.shlib
do
    source ${ITER}
done

## option selection
while getopts "chik:t" OPT
do
    case "${OPT}" in
        'c')
            main
            _sabnzbd_configure
            _finish_configure
            exit 0
            ;;
        'h')
            _usage
            ;;
        'i')
            main
            _users
            _storage
            _apt
            _sabnzbd
            _nzbhydra2
            _lidarr
            _sonarr
            _radarr
            _lazylibrarian
            _plex
            _tautulli
            _finish
            _clean
            exit 0
            ;;
        'k')
            pass an arg to ${OPTARG}
            ;;
        't')
            main
            clear
            _menu
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
