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

  Level level;
  //Point goal;
  //GameField gamefield;
  //PlayerTank player;
  Timer t;
  int currentLevel = 0;
  int levelCount = 0;


  Game(){

  }

  Future loadMeta(){
    return HttpRequest.getString("../json/meta.json").then((json) {
      Map m = JSON.decode(json);
      this.levelCount = m['lvlCount'];
    });
  }


  Future startloop(int delay) {
    Future f = LevelLoader.load(currentLevel, (level) {
      this.level = level;
      print(level);
    });
    print(level);

    this.t = new Timer.periodic(new Duration(milliseconds: 500), (t){
      this.levelLoop();
    }) ;
    return f;
  }

  continueLoop(){
    this.t = new Timer.periodic(new Duration(milliseconds: 500), (t){
      this.levelLoop();
    });
  }

  void stoploop(){
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

  /**
   * @return true on completion, false if lost
   */
  void levelLoop() {
    print(levelCount);
    Moveable tank;
      level.gamefield.moveables.forEach((m) {
        m.move();
        print("(" + m.positions[0][0].x.toString() + "," + m.positions[0][0].y.toString() + ")");
        if (m is PlayerTank)
          tank = m;
      });
      _checkWinLose(tank);
  }

  void _checkWinLose(Moveable tank){
    if(level.player.health < 1)
      print("player dead");
    if(level.gamefield.moveables.length < 1)
      print("amount of moveables: " + level.gamefield.moveables.length.toString());
    if (tank.positions[0][0].x == level.goal.x && tank.positions[0][0].y == level.goal.y) {
      stoploop();
      LevelLoader.load(1, (level) {
        this.level = level;
      });
    }
    //if(gamefield.getField(goal).ground is! Goal)
    //  print("what happened to the goal" + gamefield.getField(goal).ground.runtimeType.toString());
  }

}
