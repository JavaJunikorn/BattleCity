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
    print(reason);
    listeners.stopListeners();
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
      game.startLoop();
      view.updateLevelCount();
      view.update(20);
      listeners.startListening();
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
}
