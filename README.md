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

Usage Description
----
- When this script is run with the "-i" option it will install all the services listed above in that order
- When this script is run with the "-c" option it will configure:
-- SABnzbd with a null Usenet provider (you must provide your own)
-- NZBHydra2 with three free indexers
-- Lidarr, Sonarr, and Radarr all using NZBHydra2 as an indexer and SABnzbd as a download client
- LazyLibrarian, Plex, and Tautulli are being worked on for smooth configuration


Requirements
----
- Ubuntu 18.04 fresh install

License and Author
----

Author:: Cesar (cesar@pissedoffadmins.com)

Copyright:: 2019, Pissedoffadmins.com
