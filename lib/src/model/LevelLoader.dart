part of BattleCity;

/**
 * has the methods needed to load a level from a Json file
 */
class LevelLoader {

  /**
   * loads the level with the given levelNr from a Json file.
   * @param levelNr the number of the Level that shall be loaded.
   * @param game the Game object the level shall be loaded to.
   * @return a Future so the calling method can wait for completion.
   */
  static Future load(final int levelNr,Game game) {
    final String path = "../json/$levelNr.json";

    return HttpRequest.getString(path).then((lvlJson) {
      Map data = JSON.decode(lvlJson);
      _levelFromMap(data, game);
    });

  }

  /**
   * decodes the json from a string to a map.
   * @param response the json code as a String.
   * @return the decoded Json as a map.
   */
  static Map onDataLoaded(String response) {
    return JSON.decode(response);
  }

  /**
   * creates a Level object from a Map which is a decoded json file.
   * @param data the decoded json file.
   * @param game the Game object, the level shall be loaded to.
   */
  static  _levelFromMap(Map data, Game game) {
    Level lvl = new Level();
    game.level = lvl;
    lvl.level = data['level'];
    lvl.rows = data['rows'];
    lvl.cols = data['cols'];
    lvl.gamefield = new GameField(lvl.rows, lvl.cols);;
    createFields(game, data);
    createTanks(game, data);

  }


  /**
   * creates the Gamefield from a map which is part of a decoded json file.
   * @param game the game Object which the gamefield will be loaded into.
   * @param data a map containing information for the gamefield.
   */
  static void createFields(Game game, Map data) {
    List list = data["gameFields"];
    for(int i = 0; i < list.length; i++){
      game.level.gamefield.setGround(new Point(list[i]["position"]["col"],list[i]["position"]["row"]), list[i]["type"]);
    }
  }

  /**
   * creates the Tanks from a map which is part of a decoded json file.
   * @param game the game Object which the Tanks will be loaded into.
   * @param data a map containing information for the Tanks.
   */
  static createTanks(Game game, Map data){
    List list = data["tanks"];
    for(int i = 0; i < list.length; i++){
      Map tank = list[i];
      Directions direction = Moveable.stringToDirection(tank["direction"]);
      new Tank.factory(tank["type"], tank["row"], tank["col"], direction, game, tank["health"]);
    }
  }


  /**
   * generates a String containing a gamefield in a Json format.
   * @param rows the amount if rows in the gamefield.
   * @param cols the amount of columns in the gamefield.
   * @return a string with the information in a Json format.
   */
  static String generateJson(int rows, int cols) {
    String json="{"
        "\"level\": 1,"
        "\"gameFields\": [";
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        json += "{\"point\": {\"row\":" + i.toString() + ",";
        json += "\"col\": " + j.toString() + "},";
        json += "\"type\": \"road\"";
        if (i.compareTo(rows-1) == 0 && j.compareTo(cols - 1) == 0) {
          json += "}]}";
        } else
          json += "},";
      }
    }
    return json;
  }

}