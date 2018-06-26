part of BattleCity;

class PlayerTank extends Tank{
  PlayerTank(int x, int y, int width, int height, Directions this.lastDirection, Game game, int speed, int health, String bulletType) : super(x, y, width, height, Directions.stop, game, speed, health, bulletType, "player", 0){
    game.level.player = this;
  }
  Directions lastDirection;

  void changeDirection(Directions newDirection) {
    if (direction == newDirection) return;
    if ((direction == Directions.up && newDirection == Directions.down) ||
        (direction == Directions.down && newDirection == Directions.up) ||
        (direction == Directions.left && newDirection == Directions.right) ||
        (direction == Directions.right && newDirection == Directions.left)) {
      this.lastDirection = this.direction;
      this.direction = Directions.stop;
      return;
    }
    direction = newDirection;
  }

  @override
  String getLevel(){
    return "";
  }

}