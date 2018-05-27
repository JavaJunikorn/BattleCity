import '../GameField.dart';
import 'Moveable.dart';
import 'Tank.dart';
import 'dart:math';

class PlayerTank extends Tank{
  PlayerTank(int x, int y, int width, int height, Directions direction, GameField gameField, int speed, int health, String bulletType) : super(x, y, width, height, direction, gameField, speed, health, bulletType, "player");

  void changeDirection(Directions newDirection){
    if(direction == newDirection) return;
    if((direction == Directions.up && newDirection == Directions.down) || (direction == Directions.down && newDirection == Directions.up) ||
        (direction == Directions.left && newDirection == Directions.right) || (direction == Directions.right && newDirection == Directions.left)){
      this.direction = Directions.stop;
      return;
    }
    direction = newDirection;
  }

}