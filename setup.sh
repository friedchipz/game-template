#!/bin/bash

#create directories
mkdir -p src include

#set for project name
read -p "Provide the game name (will be used as main GameMode class name also): " gamename
gamename=$(echo $gamename | sed -e 's/[ \t]/_/g' | sed -e 's/__/_/g')
if [ "$gamename" == "" ]; then gamename="NewGame"; fi

#create the header for main gamemode
cat > include/$gamename.h <<EOF
#ifndef _${gamename}_H
#define _${gamename}_H

#include <GameMode.h>

//your main GameMode class
class $gamename : public GameMode{
public:
    $gamename();
};

#endif
EOF

#create the source for main gamemode
cat > src/$gamename.cpp <<EOF
#include <GameMode.h>
#include <${gamename}.h>

${gamename}::${gamename}(){
    gameName = "${gamename}";
}

EOF

#update the GameConfig.mk file
read -p "Path for SDL2 include folder (empty for default /usr/include/SDL2): " SDL_INCLUDE
read -p "Path for SDL2 library folder (empty for default /usr/lib/x86_64-linux-gnu): " SDL_LIB
[[ "$SDL_INCLUDE" == "" ]] && SDL_INCLUDE=/usr/include/SDL2
[[ "$SDL_LIB" == "" ]] && SDL_LIB=/usr/lib/x86_64-linux-gnu
setname='s/\(GAME[\t ]*:=\).*/\1 '$gamename'/'
setinc='s@^##\(SDL_INCLUDE[\t ]*:=\).*@\1 '"$SDL_INCLUDE"'@'
setlib='s@^##\(SDL_LIB[\t ]*:=\).*@\1 '"$SDL_LIB"'@'
sed -e "$setname" -e "$setinc" -e "$setlib" -i GameConfig.mk

make clean
make
