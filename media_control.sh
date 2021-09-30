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
    local _mntCNT=$(grep -c opt <(df -h))
    if [ "${_mntCNT}" -lt 5 ]
    then
	clear
	printf "\n%s\n\n" \
	    "${RED}. . .Drives not mounted. . .${CLR}"

	exit 1
    fi
}


function _start()
{
    for ITER in ${_SVCS}
    do
	sudo systemctl start ${ITER}.service
    done
}


function _stop()
{
    for ITER in ${_SVCS}
    do
	sudo systemctl stop ${ITER}.service
    done
}


function _restart()
{
    for ITER in ${_SVCS}
    do
	sudo systemctl restart ${ITER}.service
    done
}


function _enable()
{
    for ITER in ${_SVCS}
    do
	sudo systemctl enable ${ITER}.service
    done
}


function _disable()
{
    for ITER in ${_SVCS}
    do
	sudo systemctl disable ${ITER}.service
    done
}


function _test()
{
    for ITER in ${_SVCS}
    do
	echo "sudo systemctl test ${ITER}.service"
    done
}

function _usage()
{
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

    -R, -r
            Restart
            This option will restart all services.

EOF
}


## option selection
while getopts "EeDdSsTtRrQqHh" OPT
do
    case "${OPT}" in
	[Ee])
	    main
	    _enable
	    ;;
	[Dd])
	    main
	    _disable
	    ;;
	[Ss])
	    main
	    _chkmnt
	    _start
	    ;;
	[Tt])
	    main
	    _stop
	    ;;
	[Rr])
	    main
	    _chkmnt
	    _restart
	    ;;
	[Qq])
	    _chkmnt
	    _test
	    ;;
	[Hh]|*)
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
