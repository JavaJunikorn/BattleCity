part of BattleCity;

/**
 * the Game class has all nessesary information and functions to run the game
 */
class Game {
  final int delay = 35; //the update frequency of the gameloop (lower is higher frequency)
  Level level; //the information to the current level
  Timer t; //the timer that calles the levelLoop
  int levelCount = 0; //the amount of levels that can be played
  int currentLevel = 0; //the current level that is played
  Set<Moveable> toRemove = new Set(); //set of Moveables that need to be removed from the gamefield
  int speedCount = 0; //counter that is passed to moveables in gameloop to manage their speeds
  Function function; //function that is calles when the game is stopped
  int score = 0; //the score that the player has achieved in the current game
  bool _running = false; //true if the game is running, false if is is stopped

  /**
   * Creates a new Game
   * @param function this funtion is called when the game is stopped.
   */
  Game(void this.function(String reason)) {
  }

  /**
   * loads the meta information needed from a Json file.
   * @return a Future, so the calling function can wait for the Json to be loaded.
   */
  Future loadMeta() {
    return HttpRequest.getString("../json/meta.json").then((json) {
      Map m = JSON.decode(json);
      this.levelCount = m['lvlCount'];
    });
  }

  /**
   * loads the next level from a Json file
   * @return a Future, so the calling function can wait for the next level to be loaded.
   */
  Future loadNextLevel() => LevelLoader.load(currentLevel, this);

    /**
   * starts the game loop
   */
  void startLoop() {
    if(_running) return;
    _running = true;
    this.t = new Timer.periodic(new Duration(milliseconds: delay), (t) {
      this.levelLoop();
    });
  }

  /**
   * stops the game loop
   */
  void stopLoop() {
    _running = false;
    this.t.cancel();
  }



  /**
   * moves all the objects on the GameField and manages Collisions
   */
  void levelLoop() {
    for (int i = 0; i < level.gamefield.moveables.length; i++) {
      level.gamefield.moveables[i].move(speedCount);
    }
    for (int i = 0; i < toRemove.length; i++) {
      for (int j = 0; j < toRemove.elementAt(i).positions.length; j++) {
        for (int k = 0; k < toRemove.elementAt(i).positions[j].length; k++) {
          level.gamefield
              .getField(toRemove.elementAt(i).positions[j][k])
              .moveable = null;
        }
      }
      level.gamefield.moveables.remove(toRemove.elementAt(i));
    }


    toRemove = new Set();
    _checkWinLose();
    speedCount++;
  }


  /**
   * checks if the game has been won or lost.
   * if the game is won or lost it is stopped.
   */
  void _checkWinLose() {
    if (level.player.health < 1 || level.gamefield.goals.length < 1) {
      stopLoop();
      currentLevel = 0;
      function("lose");
    }
    if(level.gamefield.enemyCount < 1){
      stopLoop();
      currentLevel++;
      function("win");
    }
  }
}
