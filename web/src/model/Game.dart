import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'grounds/Goal.dart';
import 'moveables/Moveable.dart';
import '../Level.dart';
import '../LevelLoader.dart';

class Game {
  final int delay = 50;
  Level level;
  Timer t;
  int levelCount = 0;
  int currentLevel = 0;
  Set<Moveable> toRemove = new Set();
  int speedCount = 0;
  Function function;

  Game(void this.function(String reason)) {
  }

  Future loadMeta() {
    return HttpRequest.getString("../json/meta.json").then((json) {
      Map m = JSON.decode(json);
      this.levelCount = m['lvlCount'];
      print("levelcount = " + levelCount.toString());
    });
  }

  Future loadNextLevel() {
    return LevelLoader.load(currentLevel, this, (level) {
      this.level = level;
      print("level = " + currentLevel.toString());
    });
  }

  void startLoop() {
    this.t = new Timer.periodic(new Duration(milliseconds: delay), (t) {
      this.levelLoop();
    });
  }

  void stopLoop() {
    this.t.cancel();
  }

  /**
   * true if exists, false if all levels have been complete
   */

  /**
   * @return true on completion, false if lost
   */
  void levelLoop() {
    print(level.player.positions[0][0]);
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
   * @return false if all goals are destroyed
   */
  bool checkGoalsThere(){
    List goals = level.gamefield.goals;
    for(int i = 0; i < goals.length; i++){
      if(level.gamefield.getField(goals[i]).ground.type == "goal")
        return true;
    }
    return false;
  }

  void _checkWinLose() {
    if (level.player.health < 1 || !checkGoalsThere()) {
      stopLoop();
      function("lose");
    }
    if(level.gamefield.enemyCount < 1){
      stopLoop();
      currentLevel++;
      function("win");
    }
  }
}
