#!/usr/bin/env bash

#===============================================================================
#          FILE: media_rollout.sh
#         USAGE: ./media_rollout.sh
#   DESCRIPTION: This script rolls out a media stack
#                Check help for description
#       OPTIONS: Check help
#  REQUIREMENTS: fresh ubuntu server install
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

clear

## option selection
while getopts "CcDdRrGgHhIi" OPT
do
    case "${OPT}" in
        [Cc])
            _menu configure
            ;;
        [Dd]|[Rr])
            _menu remove
            ;;
        [Gg])
            _info >&2
            exit 0
            ;;
        [Ii])
            _menu install
            ;;
        [Hh]|*)
            _usage >&2
            exit 1
            ;;
    esac
done
if [[ ${OPTIND} -eq 1 ]]
then
    _usage >&2
    exit 1
fi
