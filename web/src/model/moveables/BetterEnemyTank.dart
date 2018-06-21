import '../Game.dart';
import 'EnemyTank.dart';
import 'Moveable.dart';
import 'dart:math';

class BetterEnemyTank extends EnemyTank{
  BetterEnemyTank(int x, int y, int width, int height, Directions direction, Game game, int speed, int health, String bulletType, String type) :
        super(x, y, width, height, direction, game, speed, health, bulletType, type);


  @override
  void move(int count){
    if(count % speed != 0)return;
    Point goal = game.level.gamefield.goals[0];
    if(goal == null)
      super.move(count);
    else{

    }
  }
}