import '../GameField.dart';
import 'Bullet.dart';
import 'EnemyTank.dart';
import 'Moveable.dart';
import 'PlayerTank.dart';
import 'dart:math';

//  38641682541006017128
abstract class Tank extends Moveable {
  int speed;
  int health;
  String bulletType;

  Tank(int x, int y, int width, int height, Directions direction,
      GameField gameField, int speed, int this.health, String this.bulletType, String type)
      : super(x, y, width, height, direction, gameField, speed, type);

  factory Tank.factory(
      String tankType, int x, int y, Directions direction, GameField field) {
    Tank t;
    switch (tankType) {
      case "player":
        {
          t = new PlayerTank(x, y, 2, 2, direction, field, 5, 10, "default");
          break;
        }
      //Todo Enemy tanks
      case "easy":
        {
          t = new EnemyTank(x, y, 2, 2, direction, field, 3, 1, "default", "easy");
          break;
        }
    }

    return t;
  }

  /**
   * @return true if destroyed else false;
   */
  hit(int dmg) {
    health -= dmg;
    if (health <= 0) {
      gameField.moveables.remove(this);
      for (List l in positions) {
        for (Point p in l) {
          gameField.getField(p).moveable = null;
        }
      }
    }
  }


  @override
  void move(){
    if(checkMovementPossible()){
      super.move();
      doCollisions();
    }
  }

  bool checkMovementPossible() {
    List<Field> pos = new List<Field>();
    switch (direction) {
      case Directions.up:
        {
          positions[0].forEach((p) => pos.add(gameField.getField(p + Moveable.UP)));
          break;
        }
      case Directions.down:
        {
          positions[positions.length-1].forEach((p) => pos.add(gameField.getField(p + Moveable.DOWN)));
          break;
        }
      case Directions.left:
        {
          positions.forEach((l) => pos.add(gameField.getField(l[0] + Moveable.LEFT)));
          break;
        }
      case Directions.right:
        {
          positions.forEach((l) => pos.add(gameField.getField(l[l.length-1] + Moveable.RIGHT)));
          break;
        }
      case Directions.stop:{
        return true;
      }
    }
    bool ret = true;
    pos.forEach((f){
      if(!f.ground.passable || f.moveable is Tank)
        ret = false;
    });
    return ret;
  }

  @override
  void doCollisions(){
    positions.forEach((l)=> l.forEach((p){
      Field f = gameField.getField(p);
      f.ground.activate(this);
      if(f.moveable is Bullet){
        Bullet b = f.moveable;
        this.hit(b.damage);
        b.hit(b.damage);
      }
    }));
  }

  void shoot() {

  }
}
