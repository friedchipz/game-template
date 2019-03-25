#include <iostream>
#include <GameMode.h>
#include GAME_HEADER
int main(int argc, char ** argv) {
	try {
		GameMode * game = new GAME();
		game->gameLoop();
		delete game;
	}
	catch (const std::exception & e) {
		std::cout << e.what() << std::endl;
	}
	return 0;
}