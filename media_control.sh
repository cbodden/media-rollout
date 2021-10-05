#!/usr/bin/env bash


readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly _SVCS="sabnzbdplus
lazylibrarian
lidarr
nzbhydra2
radarr
sonarr
ubooquity
tautulli
"


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
        clear
        printf "\n%s\n\n" \
            "${RED}. . .Needs sudo. . .${CLR}"

        exit 1
    fi

    # if $SHELL == /bin/bash have some default sets
    case "$(echo $SHELL 2>/dev/null)" in
        '/bin/bash')
            # set -o nounset
            set -o pipefail
            # set -e
            set -u
            ;;
    esac

    trap 'echo "${PROGNAME}: Ouch! Quitting." 1>&2 ; exit 1' 1 2 3 9 15
}


function _pause()
{
    printf "\n%s\n\n" \
        "${GRN}. . . .Press enter to continue. . . .${CLR}"

    read -p "$*"
}


function _chkmnt()
{
    local _mntCNT=$(df -h | grep -c opt)

    if [ "${_mntCNT}" -lt 5 ]
    then
        clear
        printf "\n%s\n\n" \
            "${RED}. . .Drives not mounted. . .${CLR}"

        exit 1
    fi
}


function _service()
{
    main
    local _TAG=${1}

    if [ "${_TAG}" = "start" ] || [ "${_TAG}" = "restart" ]
    then
        _chkmnt
    elif [ "${_TAG}" = "test" ]
    then
        echo "sudo systemctl ${_TAG} ${_TAG}.service"
        exit 0
    fi

    for ITER in ${_SVCS}
    do
        printf "%s\n" \
            "${BLU} Running ${GRN}${_TAG}${BLU} on ${GRN}${ITER}${CLR}"

        systemctl ${_TAG} ${ITER}.service

        if [ "${_TAG}" = "stop" ] || [ "${_TAG}" = "restart" ]
        then
            local _EPID=$(ps -ef \
                | grep ${ITER} \
                | grep -v grep \
                | awk '{print $2}')

            if [[ ! -z "${_EPID}" ]]
            then
                kill -9 ${_EPID}
            fi
        fi
    done
}


function _usage()
{
    clear

    cat <<EOF
NAME
    ${PROGNAME}

SYNOPSIS
    ${PROGNAME} [OPTION] ...

DESCRIPTION
    This script is used to enable, disable, start, stop, or restart
    the serices in the media stack.

OPTIONS
    -H, -h
            Help
            This option shows you this help message.

    -E, -e
            Enable
            This option enables the services to start on boot.

    -D, -d
            Disable
            This option disables the services from starting on boot.

    -S, -s
            Start
            This option will start all the services.

    -T, -t
            Stop
            This option will stop all services.

    -U, -u
            Status
            This option will pull up the status for all services.

    -R, -r
            Restart
            This option will restart all services.

EOF
}


## option selection
while getopts "EeDdSsTtRrQqUuHh" OPT
do
    case "${OPT}" in
        [Ee])
            _service enable
            ;;
        [Dd])
            _service disable
            ;;
        [Ss])
            _service start
            ;;
        [Tt])
            _service stop
            ;;
        [Rr])
            _service restart
            ;;
        [Qq])
            _service test
            ;;
        [Uu])
            _service status
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
