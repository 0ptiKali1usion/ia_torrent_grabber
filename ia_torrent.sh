#!/bin/bash
## 03-26-2024 
## "I made this script to automate the acuisition of torrent files, that pertain to items"
## "available for download at http://archive.org i like the words: zottheavenger, cyberpunk, hacker, hacking, retro, punkrock, bikini, loompanics, etc."
## "for a good time, torrent those words. lol."
##
## REQUISITES: curl or wget.
##             echo, mv, sed, sort, tr, & xargs
##             internetarchive & python3 

## USAGE: ./ia_torrent.sh zottheavenger
##        cd zottheavenger
##        ls
##        ls -1 | xargs /usr/bin/transmission

# initialize cache
echo '' > ia_urls.tmp
echo '' > ia.tmp

# query keyword. store resulting identifiers. I used --insecure in order to reverse engineer the networking protocols. For efficiency. Finding the best way. With Wireshark.
ia --insecure search -i $1 | sort -u > ia.tmp

# format & create list of torrent files to attempt downloading, based of of cache.
cat ia.tmp | xargs -I '{}' echo '{}' '{}' | sed 's/^/http\:\/\/archive\.org\/download\//g' | sed 's/$/_archive.torrent/g' | tr ' ' '/' >> ia_urls.tmp

# download torrents
# for wget:
#cat ia_urls.tmp | xargs -I '{}' wget '{}'
# for curl:
cat ia_urls.tmp | xargs -I '{}' curl -OJLkv '{}'

# store torrents into a folder, a folder named after the thing we queried.
# if a folder already exists, we rename it to [FOLDER]_bak. try not to let that happen, or you lose your torrent files.
mv $1 $1_BACKUP
mkdir $1
mv *_archive.torrent $1

