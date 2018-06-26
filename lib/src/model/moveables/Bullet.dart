part of BattleCity;

class Bullet extends Moveable {
  int damage = 1;
  bool _destroyed = false; //true if the bullet is destroyed, else false
  Tank owner;

  /**
   * creates a Bullet
   *
   * @param x see Moveable
   * @param y see Moveable
   * @param width see Moveable
   * @param height see Moveable
   * @param direction see Moveable
   * @param game see Moveable
   * @param speed see Moveable
   * @param damage the damage caused by this bullet
   * @param type see Moveable
   * @param owner the Tank that shot this bullet
   */
  Bullet._internal(int x, int y, int width, int height, Directions direction,
      Game game, int speed, int this.damage, String type, Tank this.owner)
      : super(x, y, width, height, direction, game, speed, type){
    doCollisions();
  }

  /**
   * creates a bullet via a given type
   * @param bulletType the type of bullet that shall be created
   * @param tank the Tank that shot the bullet
   * @param game a reference to the game that the bullet belongs to
   */
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

  /**
   * determines the top left position of a bullet when shot
   * @param t the tank shooting the bullet
   * @param direction the direction the bullet is flying
   * @param width zje width of the bullet
   * @param height the height of the bullet
   * @return the top left position of the bullet
   */
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

  /**
   * see Moveable
   * on hit thr bullet is destroyed
   */
  @override
  void hit(int dmg, Moveable causedBy) {
    this._destroyed = true;
    game.toRemove.add(this);
  }

  /**
   * see moveable
   * collisions are checked before moving
   */
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

  /**
   * see Moveable
   */
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


  /**
   * see Moveable
   */
  @override
  String getLevel() {
    return this.damage.toString();
  }
}
