include GameConfig.mk
CPP		:= g++
CPP_FLAGS := -fPIC -std=c++17 -Wall -Wextra -O3

ROOT	:= .
BINDIR	:= $(ROOT)/bin
LIBDIR	:= $(ROOT)/lib
INCDIR	:= $(ROOT)/include
SRCDIR	:= $(ROOT)/src
OBJDIR	:= $(ROOT)/obj

SRC		:= $(notdir $(wildcard $(SRCDIR)/*.cpp ))
OBJ		:= $(addprefix $(OBJDIR)/, $(patsubst %.cpp, %.o, $(SRC)))
LIBRARIES	:= -lm -lSDL2main


.PHONY : cook engine clean veryclean linkggame game

cook: launcher
	## do things for packaging

launcher: game
	## do this g++ whatever in launcher/main.cpp ...
	mkdir -p bin
	$(CPP) $(CPP_FLAGS) -D GAME=$(GAME) -D GAME_HEADER=\"$(GAME).h\" -I$(INCDIR) -Iengine/include -I$(SDL_INCLUDE) -L$(SDL_LIB) -L$(LIBDIR) launcher/main.cpp -o $(BINDIR)/$(GAME) $(LIBRARIES) -lSDL2 -lEngine -lGame

game: engine linkgame

linkgame: $(OBJ)
	mkdir -p lib
	$(CPP) $(CPP_FLAGS) -shared -L$(SDL_LIB) -L$(LIBDIR) $^ -o $(LIBDIR)/$(GAME_TARGET) $(LIBRARIES) -lSDL2 -lEngine

$(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	mkdir -p obj
	$(CPP) $(CPP_FLAGS) -I$(INCDIR) -I$(SDL_INCLUDE) -L$(SDL_LIB) -c -o $@ $<	

engine:
	if [ ! -d engine ]; then git clone $(ENGINE_ORIGIN); fi
	cd engine && \
	git checkout $(ENGINE_VERSION) && \
	git pull &&\
	make build SDL_INCLUDE=$(SDL_INCLUDE) SDL_LIB=$(SDL_LIB)
	mkdir -p lib
	ln -f -s ../engine/lib/$(ENGINE_TARGET) lib/$(ENGINE_TARGET)

$(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	$(CPP) $(CPP_FLAGS) -I$(INCDIR) -I$(SDL_INCLUDE) -Iengine/include -c -o $@ $<

clean:
	$(RM) -r $(OBJDIR)
	if [ -d engine ]; then cd engine && make clean; fi

## still pending of review below this line

veryclean: clean
	$(RM) -r $(BINDIR)
