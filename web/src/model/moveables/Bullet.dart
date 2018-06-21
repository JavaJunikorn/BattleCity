import '../Game.dart';
import '../GameField.dart';
import '../grounds/Goal.dart';
import '../grounds/Ground.dart';
import 'Moveable.dart';
import 'dart:math';
import 'PlayerTank.dart';
import 'Tank.dart';

class Bullet extends Moveable {
  int damage = 1;
  bool _destroyed = false;
  Tank owner;

  /**
   * @param gamefield a reference to the field the bullet is in
   * @param direction the direction the bullet is flying in
   * @param y the y position of the top left field of the Bullet
   * @param x the x position of the top left field of the Bullet
   */
  Bullet._internal(int x, int y, int width, int height, Directions direction,
      Game game, int speed, int this.damage, String type, Tank this.owner)
      : super(x, y, width, height, direction, game, speed, type){
    doCollisions();
  }

  factory Bullet(String bulletType, Tank tank, Game game) {
    Bullet b;
    Directions direction;
    if (tank.direction == Directions.stop) {
      if (tank is PlayerTank) {
        direction = tank.lastDirection;
      }
    } else {
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
          if (direction == Directions.up || direction == Directions.down) {
            b = new Bullet._internal(
                p.x, p.y, 2, 1, direction, game, 5, 1, "bullet", tank);
          } else if (direction == Directions.left ||
              direction == Directions.right) {
            b = new Bullet._internal(
                p.x, p.y, 1, 2, direction, game, 5, 1, "bullet", tank);
          }
        }
    }
    return b;
  }

  static Point getStartPosition(
      Tank t, Directions direction, int width, int height) {
    int x, y;
    switch (direction) {
      case Directions.up:
        {
          y = t.positions[0][0].y - 1;
          x = t.positions[0][(t.positions[0].length / 2).floor()].x -
              (width / 2).floor();
          break;
        }
      case Directions.down:
        {
          y = t.positions[t.positions.length - 1][t.positions[0].length - 1].y +
              1;
          x = t.positions[0][(t.positions[0].length / 2).floor()].x -
              (width / 2).floor();
          break;
        }
      case Directions.left:
        {
          x = t.positions[0][0].x - 1;
          y = t.positions[0][(t.positions.length / 2).floor()].y +
              (height / 2).floor();
          break;
        }
      case Directions.right:
        {
          x = t.positions[t.positions.length - 1][t.positions[0].length - 1].x +
              1;
          y = t.positions[0][(t.positions.length / 2).floor()].y +
              (height / 2).floor();
          break;
        }
      case Directions.stop:
        {
          break;
        }
    }
    return new Point(y, x);
  }

  @override
  void hit(int dmg, Moveable causedBy) {
    this._destroyed = true;
    game.toRemove.add(this);
  }

  void move(int count) {
    if (speed == 0 || count % speed != 0) return;
    if(positions[0][0].x < 0 || positions[0][0].y < 0 || positions[positions.length-1][positions[0].length-1].x >= game.level.cols || positions[positions.length-1][positions[0].length-1].y >= game.level.rows)
      return;
    switch (direction) {
      case Directions.up:
        {
          positions[positions.length - 1]
              .forEach((p) => game.level.gamefield.getField(p).moveable = null);

          movePositions(Moveable.UP);
          doCollisions();

          positions[0].forEach((p) {
            game.level.gamefield.getField(p).moveable = this;
          });

          break;
        }
      case Directions.down:
        {
          positions[0]
              .forEach((p) => game.level.gamefield.getField(p).moveable = null);

          movePositions(Moveable.DOWN);
          doCollisions();

          positions[positions.length - 1].forEach((p) {
            game.level.gamefield.getField(p).moveable = this;
          });
          break;
        }
      case Directions.left:
        {
          positions.forEach((l) =>
              game.level.gamefield.getField(l[l.length - 1]).moveable = null);

          movePositions(Moveable.LEFT);
          doCollisions();

          positions.forEach((l) {
            game.level.gamefield.getField(l[0]).moveable = this;
          });

          break;
        }
      case Directions.right:
        {
          positions.forEach(
              (l) => game.level.gamefield.getField(l[0]).moveable = null);

          movePositions(Moveable.RIGHT);
          doCollisions();

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

  @override
  void doCollisions() {
    if(this._destroyed) return;
    List<Moveable> hit = new List();
    for (int i = 0; i < positions.length; i++) {
      for (int j = 0; j < positions[i].length; j++) {
        Field f = game.level.gamefield.getField(positions[i][j]);

        f.ground.activate(this);
        if (!f.ground.permeable) {
          this.hit(damage, this);
        }
        if (f.ground.destroyable) {
          if(f.ground is Goal)
            game.level.gamefield.goals.removeWhere((g)=> g == positions[i][j]);
          f.ground = new Ground.factory("road");

        }
          if (f.moveable != null && f.moveable != this && !hit.contains(f.moveable)) {
            f.moveable.hit(this.damage, owner);
            this.hit(damage, f.moveable);
            hit.add(f.moveable);
          }
        }
      }
    }


  @override
  String getLevel() {
    return this.damage.toString();
  }
}
