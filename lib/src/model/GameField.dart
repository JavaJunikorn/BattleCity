part of BattleCity;

/**
 * Contains all the informtaion of the Gamefield.
 */
class GameField {
  int height; //the height of the gamefield
  int width;  //the width of the gamefield
  List<List<Field>> gameField; //the Fields that the gameField is made of
  List<Tank> moveables; //the moveable objects on the gamefield
  List<Point> goals = new List(); //the positions of goals on the gamefield
  int enemyCount = 0; // the amount of enemies left on the gamefield

  /**
   * creates a new gamefield with the given dimensions.
   * a layer of Barriers is created around the gamefield.
   * @param height the height of the field, barriers outside excluded.
   * @param width the width of the field, barriers outside excluded.
   */
  GameField(int this.height, int this.width) {
    moveables = new List<Moveable>();
    gameField = new List(height + 2);
    for (int i = 0; i < height + 2; i++) {
      gameField[i] = new List<Field>(width + 2);
      for (int j = 0; j < width + 2; j++) {
        gameField[i][j] = new Field();
        gameField[i][j].ground = new Ground.factory("road");
      }
    }

    //create outer fields as unpassable
    for (int i = 0; i < height + 2; i++) {
      gameField[i][0].ground = new Ground.factory("barrier");
      gameField[i][width + 1].ground = new Ground.factory("barrier");
    }

    for (int i = 1; i < width + 1; i++) {
      gameField[0][i].ground = new Ground.factory("barrier");
      gameField[height + 1][i].ground = new Ground.factory("barrier");
    }
  }


  /**
   * @param p a point on the gameField.
   * @return the field on the position p of the gamefield.
   */
  Field getField(Point p) {
    return gameField[p.y + 1][p.x + 1];
  }

  /**
   * sets the ground on a given position if the gamefield.
   * @param desination the position where the ground shall be set.
   * @param groundType the type of ground that shall be set.
   */
  void setGround(Point destination, String groundType) {
    getField(destination).ground = new Ground.factory(groundType);
    if(groundType == "goal"){
      goals.add(destination);
    }
  }
}


