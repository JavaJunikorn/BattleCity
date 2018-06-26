part of BattleCity;

class GameField {
  int height;
  int width;
  List<List<Field>> gameField;
  List<Tank> moveables;
  List<Point> goals = new List();
  int enemyCount = 0;

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

  Field getField(Point p) {
    return gameField[p.y + 1][p.x + 1];
  }

  void setGround(Point destination, String groundType) {
    getField(destination).ground = new Ground.factory(groundType);
    if(groundType == "goal"){
      goals.add(destination);
    }
  }
}

class Field {
  Moveable moveable;
  Ground ground;
}
