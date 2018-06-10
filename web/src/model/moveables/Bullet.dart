import '../GameField.dart';
import '../grounds/Ground.dart';
import 'Moveable.dart';
import 'dart:math';
import 'PlayerTank.dart';
import 'Tank.dart';

class Bullet extends Moveable {
  int speed = 5; //lower is faster
  int damage = 1;

  /**
   * @param gamefield a reference to the field the bullet is in
   * @param direction the direction the bullet is flying in
   * @param y the y position of the top left field of the Bullet
   * @param x the x position of the top left field of the Bullet
   */
  Bullet._internal(int x, int y, int width, int height, Directions direction,
      GameField gameField, int speed, int this.damage, String type)
      : super(x, y, width, height, direction, gameField, speed, type);


  factory Bullet(String bulletType, Tank tank,
      GameField gameField) {
    Bullet b;
    Directions direction;
    if(tank.direction == Directions.stop){
      if(tank is PlayerTank){
        direction = tank.lastDirection;
      }
    }else{
      direction = tank.direction;
    }

    switch (bulletType) {
      case "weak":
        {
          break;
        }
      default:
        {
          Point p = getStartPosition(tank, direction, 2, 1);
          b = new Bullet._internal(
              p.x, p.y, 2, 1, direction, gameField, 4, 1, "bullet");
        }
    }
    return b;
  }

  static Point getStartPosition(Tank t, Directions direction, int width, int height) {
    int x,y;
    switch (direction){
      case Directions.up:{
        y = t.positions[0][0].y - 1;
        x = t.positions[0][(t.positions[0].length/2).floor()].x - (width/2).floor();
        break;
      }
      case Directions.down:{
        y = t.positions[t.positions.length-1][t.positions[0].length-1].y + 1;
        x = t.positions[0][(t.positions[0].length/2).floor()].x - (width/2).floor();
        break;
      }
      case Directions.left:{
        x = t.positions[0][0].x - 1;
        y = t.positions[0][(t.positions.length/2).floor()].y + (height/2).floor();
        break;
      }
      case Directions.right:{
        x = t.positions[t.positions.length-1][t.positions[0].length-1].x +1;
        y = t.positions[0][(t.positions.length/2).floor()].y + (height/2).floor();
        break;
      }
      case Directions.stop:{
        break;
      }
    }
    return new Point(y, x);

  }


  @override
  void hit(int dmg) => positions.forEach((l) => l.forEach((p) {
        gameField.getField(p).moveable = null;
        gameField.moveables.remove(this);
      }));


  @override
  void move(){
    super.move();
    doCollisions();
  }

  @override
  void doCollisions() => positions.forEach((l) => l.forEach((p) {
        Field f = gameField.getField(p);
        f.ground.activate(this);
        if (!f.ground.permeable) {
          this.hit(damage);
        }
        if (f.ground.destroyable) f.ground = new Ground.factory("road");
        if (f.moveable is Bullet) {
          this.hit(damage);
        }
        f.moveable.hit(damage);
      }));
}
