part of BattleCity;

abstract class Tank extends Moveable {
  int speed;
  int health;
  String bulletType;
  bool readyToShoot = true;
  int shootSpeed = 1000; //lower means shooting can be done more often
  int score;

  Tank(int x, int y, int width, int height, Directions direction, Game game,
      int this.speed, int this.health, String this.bulletType, String type, int score)
      : super(x, y, width, height, direction, game, speed, type){
    this.score = score * health;
  }

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

  @override
  String getLevel() {
    return health.toString();
  }


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

  @override
  void move(int count) {
    if (count % speed != 0) return;
    if (checkMovementPossible()) {
      super.move(count);
      doCollisions();
    }
  }

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
