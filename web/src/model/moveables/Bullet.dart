import '../GameField.dart';
import '../grounds/Ground.dart';
import 'Moveable.dart';

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


      factory Bullet(String bulletType, int x, int y, Directions direction, GameField gameField){
        Bullet b;
        switch (bulletType){
          case "weak":{

            break;
          }
          default:{
            b = new Bullet._internal(x, y, 2, 1, direction, gameField, 4, 1, "bullet");
          }
        }

        return b;
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
