import 'GameField.dart';
import 'dart:async';
import 'grounds/Goal.dart';
import 'grounds/Ground.dart';
import 'moveables/Moveable.dart';
import 'moveables/PlayerTank.dart';
import 'dart:math';
import 'moveables/Tank.dart';

class Game {

  Map<Point, Moveable> moveables = new Map();



  Map<Point, Ground> grounds = new Map();
  Point goal;
  GameField gamefield;
  PlayerTank player;
  int level = 1;
  int count = 0;
  Timer t;
  Game(){

  }


  void startloop(){
    this.t = new Timer.periodic(new Duration(milliseconds: 500), (t){
      this.levelLoop();
    }) ;
  }
  void stoploop(){
    this.t.cancel();
  }

  /**
   * true if exists, false if all levels have been complete
   */
  bool generateField(int level) {
    //TODO
    player = new PlayerTank(0, 0, 2, 2, Directions.right, gamefield, 2, 10, "");
    //Tank t = new PlayerTank(2, 2, 1, 1, Directions.stop, gamefield, 10, 10, "");
    return true;
  }

  /**
   * @return true on completion, false if lost
   */
  void levelLoop() {
      gamefield.moveables.forEach((m) {
        m.move();
      });
      _checkWinLose();
  }

  void _checkWinLose(){
    if(player.health < 1)
      print("player dead");
    if(gamefield.moveables.length < 1)
      print("amount of moveables: " + gamefield.moveables.length.toString());
    //if(gamefield.getField(goal).ground is! Goal)
    //  print("what happened to the goal" + gamefield.getField(goal).ground.runtimeType.toString());
  }
}
