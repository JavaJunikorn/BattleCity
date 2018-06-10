import 'dart:math';
import 'model/moveables/PlayerTank.dart';
import 'model/GameField.dart';
import 'model/moveables/Moveable.dart';

class Level {
  int level;
  int cols;
  int rows;
  Point goal;
  PlayerTank player;
  GameField gamefield;
}
