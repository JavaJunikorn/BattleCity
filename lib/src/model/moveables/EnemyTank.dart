part of BattleCity;


class EnemyTank extends Tank {
  EnemyTank(int x, int y, int width, int height, Directions direction,
      Game game, int speed, int health, String bulletType, String type, int score)
      : super(x, y, width, height, direction, game, speed, health, bulletType, type, score){
   game.level.gamefield.enemyCount++;
  }

  @override
  move(int count) {
    if(health < 1)return;
    if (speed == 0 || count % speed != 0) return;
    Random rnd = new Random();
    if (!checkMovementPossible()) {
      moveRandomly();
    } else {
      int i = rnd.nextInt(20);
      if (i == 0) {
        moveRandomly();
      }
    }
    super.move(count);
    doCollisions();
    int i = rnd.nextInt(3);
    if (i == 0) this.shoot();
  }


void moveRandomly(){
  var rnd = new Random();
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
}
