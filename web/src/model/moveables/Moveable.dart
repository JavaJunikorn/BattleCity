import '../Game.dart';
import '../GameField.dart';
import 'dart:math';
import 'PlayerTank.dart';

enum Directions { left, right, up, down, stop }

abstract class Moveable {
  static const Point UP = const Point(0, -1);
  static const Point DOWN = const Point(0, 1);
  static const Point LEFT = const Point(-1, 0);
  static const Point RIGHT = const Point(1, 0);
  static const Point STOP = const Point(0, 0);
  List<List<Point>> positions;
  Directions direction;
  Game game;
  int speed;
  int height;
  int width;
  String type;

  /**
   * (x,y) topLeft position of the Object
   */
  Moveable(int x, int y, int this.width, int this.height, Directions this.direction,
      Game this.game, int this.speed, String this.type) {
    positions = new List(height);
    for (int row = 0; row < height; row++) {
      positions[row] = new List(width);
      for (int col = 0; col < width; col++) {
        positions[row][col] = new Point(col + y, row + x);
        game.level.gamefield.getField(new Point(y + col, x + row)).moveable =
            this;
      }
    }
    game.level.gamefield.moveables.add(this);
  }


  String getLevel();

  void move(int count) {
    if (speed == 0 && count % speed != 0) return;
    switch (direction) {
      case Directions.up:
        {
          positions[positions.length - 1]
              .forEach((p) => game.level.gamefield.getField(p).moveable = null);

          movePositions(UP);

          positions[0].forEach((p) {
            game.level.gamefield.getField(p).moveable = this;
          });

          break;
        }
      case Directions.down:
        {
          positions[0]
              .forEach((p) => game.level.gamefield.getField(p).moveable = null);

          movePositions(DOWN);
          positions[positions.length - 1].forEach((p) {
            game.level.gamefield.getField(p).moveable = this;
          });
          break;
        }
      case Directions.left:
        {
          positions.forEach((l) =>
              game.level.gamefield.getField(l[l.length - 1]).moveable = null);

          movePositions(LEFT);

          positions.forEach((l) {
            game.level.gamefield.getField(l[0]).moveable = this;
          });

          break;
        }
      case Directions.right:
        {
          positions.forEach(
              (l) => game.level.gamefield.getField(l[0]).moveable = null);

          movePositions(RIGHT);

          positions.forEach((l) {
            game.level.gamefield.getField(l[l.length - 1]).moveable = this;
          });

          break;
        }
      case Directions.stop:
        {
          break;
        }
    }
  }

  void movePositions(Point direction) {
    for (int i = 0; i < positions.length; i++) {
      for (int j = 0; j < positions[i].length; j++) {
        positions[i][j] += direction;
      }
    }
  }

  void hit(int dmg);

  void doCollisions();

  static String directionOf(Moveable m) {
    if (m.direction == Directions.stop) {
      if (m is PlayerTank) {
        return directionToString(m.lastDirection);
      }
    }
    return directionToString(m.direction);
  }

  static String directionToString(Directions direction) {
    String s;
    switch (direction) {
      case Directions.up:
        s = "up";
        break;
      case Directions.down:
        s = "down";
        break;
      case Directions.left:
        s = "left";
        break;
      case Directions.right:
        s = "right";
        break;
      case Directions.stop:
        break;
    }
    return s;
  }

  static Directions stringToDirection(String s) {
    switch (s){
      case "up":
        return Directions.up;
      case "down":
        return Directions.down;
      case "left":
        return Directions.left;
      case "right":
        return Directions.right;
    }
    return Directions.stop;
  }
}
