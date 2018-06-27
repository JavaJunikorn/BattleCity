part of BattleCity;

/**
 * the Tank which the player controlls
 */
class PlayerTank extends Tank{

  Directions lastDirection;

  /**
   * see Tank
   *
   * @param lastDirection the direction the tank is facing. It is not moving when created.
   */
  PlayerTank(int x, int y, int width, int height, Directions this.lastDirection, Game game, int speed, int health, String bulletType) : super(x, y, width, height, Directions.stop, game, speed, health, bulletType, "player", 0){
    game.level.player = this;
  }


  /**
   * changes the direction the tank is facing
   * @param newDirection the direction the tank shall face
   */
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


  /**
   * see Tank
   */
  @override
  String getLevel(){
    return "";
  }

}