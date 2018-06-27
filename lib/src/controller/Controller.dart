part of BattleCity;

class Controller {
  Game game; // the game this controller is working on
  View view; // the view for the game
  Listeners listeners; // the Listeners used

  /**
   * creates a new Controller
   * game and view are automatically created
   */
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

  /**
   * function that is called when the game is stopped
   * @param reason the reason the game has stopped
   */
  void gamepaused(String reason) {
    view.pauseLoop();
    listeners.pauseListening();
    if (reason == "lose") {
      game.currentLevel = 1;
      view.showLose();
      game.score = 0;

    } else if (reason == "win") {
      if (game.currentLevel >= game.levelCount) {
        view.showWin();
        game.currentLevel = 1;
      } else {
        startLevel();
      }
    }
  }

  /**
   * load the main menu
   */
  void mainMenu() {
    view.showMainMenu();
    listeners.startMenuListeners();
  }

  /**
   * starts the next level of the game, starts the listeners used for controlling the playertank and the View
   */
  void startLevel() {
    view.showLoading();
    game.loadNextLevel().whenComplete(() {

      view.startLoop();
      listeners.resumeListening();
      game.startLoop();
    }).whenComplete(() { pause();});
  }

  /**
   * continue the view, listeners for controlling the playertank and the game
   */
  void resume() {
    view.resumeLoop();
    listeners.resumeListening();
    game.startLoop();
  }

  /**
   * pause the view, listeners for controlling the playertank and the game
   */
  void pause(){
    view.pauseLoop();
    listeners.pauseListening();
    game.stopLoop();

  }
}
