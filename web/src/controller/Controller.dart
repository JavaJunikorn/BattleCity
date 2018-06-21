import '../model/Game.dart';
import '../view/View.dart';
import 'Listeners.dart';

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
      listeners.starMenuListeners();
    });
  }

  void gamepaused(String reason) {
    listeners.pauseListening();
    if (reason == "lose") {
      view.showLose();
    } else if (reason == "winLevel") {
      if (game.currentLevel >= game.levelCount)
        view.showCongrats();
      else {
        startLevel();
      }
    }
  }

  void mainMenu() {
    view.showMainMenu();
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
