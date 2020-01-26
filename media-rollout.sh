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
while getopts "dhi" OPT
do
    case "${OPT}" in
        'd')
            clear
            _info
            ;;
        'h')
            clear
            _usage
            ;;
        'i')
            main
            clear
            _menu
            ;;
        *)
            clear
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
