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
    game.loadMeta().whenComplete(() {
      mainMenu();
    });
  }

  void gamepaused(String reason) {
    view.pauseLoop();
    listeners.pauseListening();
    if (reason == "lose") {
      view.showLose();
      game.score = 0;

    } else if (reason == "win") {
      if (game.currentLevel >= game.levelCount)
        //Todo replace with win screen
        mainMenu();
      else {
        startLevel();
      }
    }
  }

  void mainMenu() {
    view.showMainMenu();
    listeners.starMenuListeners();
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

  void restartGame() {
    game = new Game((String reason) {
      {
        gamepaused(reason);
      }
    });
    view = new View(game, this);
    listeners = new Listeners(this, game);
    game.loadMeta().whenComplete(() {
      mainMenu();
      listeners.starMenuListeners();
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
