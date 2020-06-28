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
while getopts "CDdhIiRr" OPT
do
    case "${OPT}" in
        'C')
            main
            _menuCONF
            exit 0
            ;;
        'D'|'R'|'r')
            main
            _menuREMOVE
            exit 0
            ;;
        'd')
            clear
            _info >&2
            ;;
        'h')
            clear
            _usage >&2
            exit 1
            ;;
        'I')
            main
            for ITER in DLOAD SRCH TV MVS SBT MUSIC MSERV TTL BOOKS BSERV
            do
                _menu${ITER}
            done

            _menuRUN
            exit 0
            ;;
        'i')
            main
            clear
            _menu
            ;;
        *)
            clear
            _usage >&2
            exit 1
            ;;
    esac
done
if [[ ${OPTIND} -eq 1 ]]
then
    clear
    _usage >&2
    exit 1
fi
