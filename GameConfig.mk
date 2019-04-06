## set the flag for initial game class like
## CPP_FLAGS	+= -D GAME=MyGame
## define the origin for engine

## if SDL is not directly accessible, uncomment and fill the lines at the bottom
## example for linux
## SDL_INCLUDE	:= /usr/include/SDL2
## SDL_LIB		:= /usr/lib/x86_64-linux-gnu

## edit below this: ##
##SDL_INCLUDE   := <path to SDL Headers>
##SDL_LIB       := <path to SDL2 library>

GAME			:= 
ENGINE_ORIGIN	:= git@github.com:friedchipz/engine.git
ENGINE_VERSION	:= master

## probably you won't need to edit anything below this.

ifeq ($(OS),Windows_NT)
	CPP_FLAGS	+= -D WINDOWS
	LIB_EXTENSION	:= dll
else
	UNAME_S	:= $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		CPP_FLAGS	+= -D LINUX
		LIB_EXTENSION	:= so
	else
		CPP_Flags	+= -D MACOS
		LIB_EXTENSION	:= dylib
	endif
endif

ENGINE_TARGET	:= libEngine.$(LIB_EXTENSION)
GAME_TARGET	:= libGame.$(LIB_EXTENSION)
