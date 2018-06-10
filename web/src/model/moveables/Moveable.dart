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
  GameField gameField;
  int speed;
  int height;
  int width;
  String type;

  /**
   * (x,y) topLeft position of the Object
   */
  Moveable(int x, int y, int this.width, int this.height,
      Directions this.direction, GameField this.gameField, int this.speed,
      String this.type) {
    print(gameField);
    print(gameField.moveables);
    gameField.moveables.add(this);
    positions = new List(height);
    for (int row = 0; row < height; row++) {
      positions[row] = new List(width);
      for (int col = 0; col < width; col++) {
        positions[row][col] = new Point(col + y, row + x);
        gameField
            .getField(new Point(y + col, x + row))
            .moveable = this;
      }
    }
  }

  void move() {
    switch (direction) {
      case Directions.up:
        {
          positions[positions.length - 1].forEach((p) =>
          gameField
              .getField(p)
              .moveable = null);

          _movePositions(Moveable.UP);

          positions[0].forEach((p) {
            gameField
                .getField(p)
                .moveable = this;
          });

          break;
        }
      case Directions.down:
        {
          positions[0].forEach((p) =>
          gameField
              .getField(p)
              .moveable = null);

          _movePositions(Moveable.DOWN);

          positions[positions.length - 1].forEach((p) {
            gameField
                .getField(p)
                .moveable = this;
          });
          break;
        }
      case Directions.left:
        {
          positions.forEach((l) =>
          gameField
              .getField(l[l.length - 1])
              .moveable = null);

          _movePositions(Moveable.LEFT);

          positions.forEach((l) {
            gameField
                .getField(l[0])
                .moveable = this;
          });

          break;
        }
      case Directions.right:
        {
          positions.forEach((l) =>
          gameField
              .getField(l[0])
              .moveable = null);

          _movePositions(Moveable.RIGHT);

          positions.forEach((l) {
            gameField
                .getField(l[l.length - 1])
                .moveable = this;
          });

          break;
        }
      case Directions.stop:
        {
          break;
        }
    }
  }

  void _movePositions(Point direction) {
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
    } else {
      return directionToString(m.direction);
    }
  }

  static String directionToString(Directions direction) {
    switch (direction) {
      case Directions.up:
        return "up";
      case Directions.down:
        return "down";
      case Directions.left:
        return "left";
      case Directions.right:
        return "right";
      case Directions.stop:
        break;
    }
  }

}
