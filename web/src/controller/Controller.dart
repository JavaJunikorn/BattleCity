import '../model/Game.dart';
import '../view/View.dart';
import 'Listeners.dart';
import 'dart:html';

class Controller {
  Game game;
  View view;
  Listeners listeners;

  Controller() {
    game = new Game((String reason) {
      {
        gamepaused(reason);
      }
    });
    view = new View(game, this);
    listeners = new Listeners(this, game);
    window.scrollTo(0, 1);
    game.loadMeta().whenComplete(() {
      mainMenu();
    });
  }

  void gamepaused(String reason) {
    view.pauseLoop();
    listeners.pauseListening();
    if (reason == "lose") {
      game.currentLevel = 1;
      view.showLose();
      game.score = 0;

    } else if (reason == "win") {
      if (game.currentLevel >= game.levelCount) {
        //Todo replace with win screen
        view.showCongrats();
        game.currentLevel = 1;
      } else {
        startLevel();
      }
    }
  }

  void mainMenu() {
    view.showMainMenu();
    listeners.startMenuListeners();
  }

  void startLevel() {
    //showloading
    game.loadNextLevel().whenComplete(() {
      //hideloading
      view.startLoop();
      listeners.resumeListening();
      game.startLoop();
    });
  }

  void resume() {
    view.resumeLoop();
    listeners.resumeListening();
    game.startLoop();
  }
  void pause(){
    view.pauseLoop();
    listeners.pauseListening();
    game.stopLoop();

  }
}
