import 'Moveable.dart';
import '../GameField.dart';
import 'Moveable.dart';
import 'Tank.dart';
import 'dart:math';

class EnemyTank extends Tank {
  EnemyTank(int x, int y, int width, int height, Directions direction,
      GameField field, int speed, int health, String bulletType, String type)
      : super(x, y, width, height, direction, field, speed, health, bulletType, type);

  @override
  move() {
    Random rnd = new Random();
    if (!checkMovementPossible()) {
      if (health > 0) {
        int i = rnd.nextInt(4);
        switch (i) {
          case 0:
            {
              this.direction = Directions.up;
              break;
            }
          case 1:
            {
              this.direction = Directions.down;
              break;
            }
          case 2:
            {
              this.direction = Directions.left;
              break;
            }
          case 3:
            {
              this.direction = Directions.right;
              break;
            }
        }
      }
    } else
      super.move();
    doCollisions();
    int i = rnd.nextInt(1);
    if (i == 0) this.shoot();
  }
}
