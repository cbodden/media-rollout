```
               .        :  .,:::::::::::::-.  :::  :::.
               ;;,.    ;;; ;;;;'''' ;;,   `';,;;;  ;;`;;
               [[[[, ,[[[[, [[cccc  `[[     [[[[[ ,[[ '[[,
               $$$$$$$$"$$$ $$""""   $$,    $$$$$c$$$cc$$$c
               888 Y88" 888o888oo,__ 888_,o8P'888 888   888,
               MMM  M'  "MMM""""YUMMMMMMMP"`  MMM YMM   ""`

:::::::..       ...      :::      :::         ...      ...    :::::::::::::::
;;;;``;;;;   .;;;;;;;.   ;;;      ;;;      .;;;;;;;.   ;;     ;;;;;;;;;;;''''
 [[[,/[[['  ,[[     \[[, [[[      [[[     ,[[     \[[,[['     [[[     [[
 $$$$$$c    $$$,     $$$ $$'      $$'     $$$,     $$$$$      $$$     $$
 888b "88bo,"888,_ _,88Po88oo,.__o88oo,.__"888,_ _,88P88    .d888     88,
 MMMM   "W"   "YMMMMMP" """"YUMMM""""YUMMM  "YMMMMMP"  "YmmMMMM""     MMM

```
Media Rollout
====

This script installs the following services :
----

- SABnzbd (https://sabnzbd.org/)
- NZBHydra2 (https://github.com/theotherp/nzbhydra2)
- Lidarr (https://lidarr.audio/)
- Sonarr (https://sonarr.tv/)
- Radarr (https://radarr.video/)
- LazyLibrarian (https://github.com/DobyTang/LazyLibrarian)
- Plex Media Server (https://www.plex.tv/)
- Tautulli (https://tautulli.com/)


Usage
----
Base Usage:
```
git clone https://github.com/cbodden/media-rollout.git
cd media-rollout
sudo ./media-rollout
```

Script Usage:
```
NAME
    media-rollout.sh

SYNOPSIS
    media-rollout.sh [OPTION] ...

DESCRIPTION
    This script is used to deploy and configure:
    SABnzbd
    NZBHydra2
    Lidarr
    Sonarr
    Radarr
    LazyLibrarian
    Plex Media Server
    Tautulli

OPTIONS
    -h
            Help
            This option shows you this help message.

    -i
            Install
            This option installs all the services without configuration.
            This option needs to be run before before "-c".

    -c
            Configure
            This option goes through the services and configures them
            to a default state but all talking to each other.
            This option must be run only after running with "-i".
```


Usage Description
----
- When this script is run with the "-i" option it will install all the services listed above in that order
- When this script is run with the "-c" option it will configure:
-- SABnzbd with a null Usenet provider (you must provide your own)
-- NZBHydra2 with three free indexers
-- Lidarr, Sonarr, Radarr, and LazyLibrarian all using NZBHydra2 as an indexer and SABnzbd as a download client
- Plex, and Tautulli are being worked on for smooth configuration
- For proper operation of LazyLibrarian you need to get a GoodReads API key


Requirements
----
- Ubuntu 18.04 (fresh install by user)
- yq (installed by this script from https://github.com/mikefarah/yq)
- mono (installed by this script from https://www.mono-project.com/)
- sqlite3 (installed by this script from https://www.sqlite.org/index.html)
- SABnzbd (installed by this script from https://sabnzbd.org/)
- NZBHydra2 (installed by this script from https://github.com/theotherp/nzbhydra2)
- Lidarr (installed by this script from https://lidarr.audio/)
- Sonarr (installed by this script from https://sonarr.tv/)
- Radarr (installed by this script from https://radarr.video/)
- LazyLibrarian (installed by this script from https://github.com/DobyTang/LazyLibrarian)
- Plex Media Server (installed by this script from https://www.plex.tv/)
- Tautulli (installed by this script from https://tautulli.com/)


Notes
----
- For questions, help, comments, or praise visit #media-rollout on freenode


License and Author
----

Author:: Cesar (cesar@pissedoffadmins.com)

Copyright:: 2019, Pissedoffadmins.com
