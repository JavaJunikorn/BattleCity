import '../model/Game.dart';
import '../view/View.dart';
import 'Direction.dart';

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
    print(reason);
    listeners.stopListeners();
    if (reason == "lose") {
      view.showLose();
    } else if (reason == "win") {
      view.showLoading();
      if (game.currentLevel > game.levelCount)
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
    game.loadNextLevel().whenComplete(() {
      game.startLoop();
      view.update(20);
      listeners.startListening();
    });
  }
}
