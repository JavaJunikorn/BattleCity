import 'GameField.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'grounds/Goal.dart';
import 'grounds/Ground.dart';
import 'moveables/Moveable.dart';
import 'moveables/PlayerTank.dart';
import 'dart:math';
import 'moveables/Tank.dart';
import '../Level.dart';
import '../LevelLoader.dart';

class Game {

  final int delay = 30;
  Level level;
  //Point goal;
  //GameField gamefield;
  //PlayerTank player;
  Timer t;
  int currentLevel = 0;
  int levelCount = 0;
  Set<Moveable> toRemove = new Set();
  int count = 0;


  Game(){

  }

  Future loadMeta(){
    return HttpRequest.getString("../json/meta.json").then((json) {
      Map m = JSON.decode(json);
      this.levelCount = m['lvlCount'];
    });
  }


  Future startloop() {
    Future f = LevelLoader.load(currentLevel, this, (level) {
      this.level = level;
    });


    f.whenComplete(() {
      this.t = new Timer.periodic(new Duration(milliseconds: delay), (t) {
        this.levelLoop();
      });
    });
    return f;
  }

  continueLoop(){
    this.t = new Timer.periodic(new Duration(milliseconds: delay), (t){
      this.levelLoop();
    });
  }

  void stopLoop(){
    this.t.cancel();
  }

  /**
   * true if exists, false if all levels have been complete
   */
  bool generateField(int level) {
    //TODO
    //player = new PlayerTank(0, 0, 2, 2, Directions.right, gamefield, 2, 10, "");
    //Tank t = new PlayerTank(2, 2, 1, 1, Directions.stop, gamefield, 10, 10, "");
    return true;
  }


  void printlevel(){String s = "";

    level.gamefield.gameField.forEach((l){
      l.forEach((f){
        s += "[" + f.ground.toString() + ", " + f.moveable.toString() + "], ";
      });
      s += "\n";
    });
    print(s);
  }

  /**
   * @return true on completion, false if lost
   */
  void levelLoop() {
      for(int i = 0; i < level.gamefield.moveables.length; i++){
        level.gamefield.moveables[i].move(count);
      }
      for(int i = 0; i < toRemove.length; i++){
        for(int j = 0; j < toRemove.elementAt(i).positions.length; j++){
          for(int k = 0; k < toRemove.elementAt(i).positions[j].length; k++){
            level.gamefield.getField(toRemove.elementAt(i).positions[j][k]).moveable = null;
          }
        }
        level.gamefield.moveables.remove(toRemove.elementAt(i));
      }
      toRemove = new Set();
      _checkWinLose();
      count++;
  }

  void _checkWinLose(){
    if(level.player.health < 1)
      print("player dead");
    if(level.gamefield.moveables.length < 1)
      print("amount of moveables: " + level.gamefield.moveables.length.toString());
    if (level.player.positions[0][0].x == level.goal.x && level.player.positions[0][0].y == level.goal.y) {
      stopLoop();
      LevelLoader.load(1, this, (level) {
        this.level = level;
      }).whenComplete((){
        continueLoop();
      });
    }
    //if(gamefield.getField(goal).ground is! Goal)
    //  print("what happened to the goal" + gamefield.getField(goal).ground.runtimeType.toString());
  }

}
