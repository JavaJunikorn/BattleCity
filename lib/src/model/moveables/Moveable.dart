part of BattleCity;

/**
 * the class containing the information and functionality of a moveable object
 */
abstract class Moveable {
  // direction vectors
  static const Point UP = const Point(0, -1);
  static const Point DOWN = const Point(0, 1);
  static const Point LEFT = const Point(-1, 0);
  static const Point RIGHT = const Point(1, 0);
  static const Point STOP = const Point(0, 0);

  List<List<Point>> positions; //the positions the object is on
  Directions direction;
  Game game;
  int speed;
  int height;
  int width;
  String type;

  /**
   * creates a new moveable object
   * @param x the x position of the top-left of the object
   * @param y the y position of the top-left of the object
   * @param width the width of the object
   * @param height the height of the object
   * @param direction the direction the object is moving
   * @param game reference to the game the object belongs to
   * @param speed the speed of the object, lower is faster
   * @param type the type of the object, used to determine what type of object it is
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


  /**
   * @return the power of the object, used to differ between objects of the same type
   */
  String getLevel();

  /**
   * moves the object in the direction it is facing
   * @param count a value that is used to determine of the object has the possibility to move
   */
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

  /**
   * updates the positions of the object
   * @param direction the vector of the direction the object is facing
   */
  void movePositions(Point direction) {
    for (int i = 0; i < positions.length; i++) {
      for (int j = 0; j < positions[i].length; j++) {
        positions[i][j] += direction;
      }
    }
  }

  /**
   * the object is hit
   * @param dmg the amount of damage this object gets
   * @param causedBy the object that is responsible for the hit
   */
  void hit(int dmg, Moveable causedBy);

  /**
   * checks collisions and carries them out
   */
  void doCollisions();

  /**
   * converts the direction of a moveable to a String
   * @param m the moveable object which direction is needed
   * @return the direction as a String
   */
  static String directionOf(Moveable m) {
    if (m.direction == Directions.stop) {
      if (m is PlayerTank) {
        return directionToString(m.lastDirection);
      }
    }
    return directionToString(m.direction);
  }

  /**
   * converts a direction to a String
   * @direction the direction that shall be converted
   * @return the direction as a String
   */
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


  /**
   * converts a string to a direction
   * @param s the String containing the direction
   * @return the direction
   */
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
