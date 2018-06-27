part of BattleCity;

/**
 * the class modelling a Tank
 */
abstract class Tank extends Moveable {
  int speed;
  int health;
  String bulletType;
  bool readyToShoot = true; //used to manage the shooting freqquency of the tank
  int shootSpeed = 1000; //frequency the tank can shoot, lower is higher frequency
  int score;

  /**
   * creates a tank
   * @param x see Moveable
   * @param y see Moveable
   * @param width see Moveable
   * @param height see Moveable
   * @param direction see Moveable
   * @param game see Moveable
   * @param speed see Moveable
   * @param health the amount of health the tank has. Also a multiplier for the score
   * @param bulletType the type of bullet the tank shoots
   * @param type see Moveable
   * @param score the amount of score the tank gives when killed by the player.
   */
  Tank(int x, int y, int width, int height, Directions direction, Game game,
      int this.speed, int this.health, String this.bulletType, String type, int score)
      : super(x, y, width, height, direction, game, speed, type){
    this.score = score * health;
  }

  /**
   * creates a tank via a type
   * @param tankType the type of Tank that shall be created
   * @param x the x position of the top-left of the tank
   * @param y the y position of the top-left of the tank
   * @param Direction the direction the tank is moving
   * @param game reference to the game this tank belongs to
   * @param health the amount of health the tank shall have
   */
  factory Tank.factory(
      String tankType, int x, int y, Directions direction, Game game, int health) {
    Tank t;
    switch (tankType) {
      case "player":
        {
          t = new PlayerTank(x, y, 2, 2, direction, game, 7, health, "default");
          break;
        }
      case "tutorial":
        t = new EnemyTank(x, y, 2, 2, direction, game, 0, health, "", "easyEnemy", 0);
        break;
      case "easy":
      {
        t = new EnemyTank(
            x, y, 2, 2, direction, game, 15, health, "default", "easyEnemy", 50);
        break;
      }
      case "med":
        {
          t = new EnemyTank(
              x, y, 2, 2, direction, game, 10, health, "weak", "medEnemy", 100);
          break;
        }
      case "strong":
        {
          t = new EnemyTank(
              x, y, 2, 2, direction, game, 7, health, "med", "strongEnemy", 150);
          break;
        }
      case "veryStrong":
        {
          t = new EnemyTank(
              x, y, 2, 2, direction, game, 4, health, "strong", "veryStrongEnemy", 200);
          break;
        }
      case "invisible":
        {
          t = new EnemyTank(
              x, y, 2, 2, direction, game, 7, health, "default", "invisibleEnemy", 100);
          break;
        }
    }

    return t;
  }

  /**
   * see Moveable
   */
  @override
  String getLevel() {
    return health.toString();
  }


  /**
   * see Moveable
   */
  hit(int dmg, Moveable causedBy) {
    if(game.toRemove.contains(this))return;
    health -= dmg;
    if (health <= 0) {
      game.toRemove.add(this);
      if(causedBy is PlayerTank){
        game.score += this.score;
      }
      if (this is! PlayerTank) {
        game.level.gamefield.enemyCount--;
      }
    }
  }

  /**
   * see moveable
   *
   * collisions are also handled
   */
  @override
  void move(int count) {
    if (count % speed != 0) return;
    if (checkMovementPossible()) {
      super.move(count);
      doCollisions();
    }
  }

  /**
   * checks if the tank can move in its current direction
   * @return true if it can move, else false
   */
  bool checkMovementPossible() {
    List<Field> pos = new List<Field>();
    switch (direction) {
      case Directions.up:
        {
          positions[0].forEach(
              (p) => pos.add(game.level.gamefield.getField(p + Moveable.UP)));
          break;
        }
      case Directions.down:
        {
          positions[positions.length - 1].forEach(
              (p) => pos.add(game.level.gamefield.getField(p + Moveable.DOWN)));
          break;
        }
      case Directions.left:
        {
          positions.forEach((l) =>
              pos.add(game.level.gamefield.getField(l[0] + Moveable.LEFT)));
          break;
        }
      case Directions.right:
        {
          positions.forEach((l) => pos.add(
              game.level.gamefield.getField(l[l.length - 1] + Moveable.RIGHT)));
          break;
        }
      case Directions.stop:
        {
          return true;
        }
    }
    bool ret = true;
    pos.forEach((f) {
      if (!f.ground.passable || f.moveable != null) ret = false;
    });
    return ret;
  }

  /**
   * see Moveable
   */
  @override
  void doCollisions() {
    positions.forEach((l) => l.forEach((p) {
          Field f = game.level.gamefield.getField(p);
          f.ground.activate(this);
          if (f.moveable is Bullet) {
            Bullet b = f.moveable;
            this.hit(b.damage, b.owner);
            b.hit(b.damage, b);
          }
        }));
  }


  /**
   * creates a bullet in front of the tank and with the same direction of the tank
   * the type of bullet created is set in bulletType
   */
  void shoot() {
    if (readyToShoot) {
      readyToShoot = false;
      new Bullet(this.bulletType, this, game);
      new Timer(new Duration(milliseconds: shootSpeed), () {
        this.readyToShoot = true;
      });
    }
  }
}
