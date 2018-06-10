import 'dart:math';
import 'model/Game.dart';
import 'model/GameField.dart';
import 'Level.dart';
import 'model/moveables/PlayerTank.dart';
import 'model/moveables/Moveable.dart';
import 'dart:convert';
import 'dart:html';
import 'dart:async';


class LevelLoader {

  static Future load(final int levelNr,Game game, void callbackFunction(Level level)) {
    final String path = "../json/$levelNr.json";

    return HttpRequest.getString(path).then((lvlJson) {
      Map data = JSON.decode(lvlJson);
      Level lvl = _levelFromMap(data, game);
      callbackFunction(lvl);
    });

  }

  static Map onDataLoaded(String response) {
    return JSON.decode(response);
  }

  static Level _levelFromMap(Map data, Game game) {
    Level lvl = new Level();
    game.level = lvl;
    lvl.level = data['level'];
    lvl.rows = data['rows'];
    lvl.cols = data['cols'];
    lvl.goal = _createFieldPointFrom(data['goal']);
    lvl.gamefield = gameFieldFromMap(data['gameFields'], lvl.rows, lvl.cols);
    lvl.player = _createPlayerTankFrom(data['playerTank'], game);
    return lvl;
  }

  static GameField gameFieldFromMap(List<Map> data, int rows, cols) {
    GameField game = new GameField(rows, cols);

    data.forEach((dimension) {
      String type = dimension["type"];
      Point pointFromMap = _createFieldPointFrom(dimension["position"]);

      game.setGround(pointFromMap, type);
    });
    return game;
  }

  static Point _createFieldPointFrom(Map data) => new Point(data["col"], data["row"]);

  static PlayerTank _createPlayerTankFrom(Map data, Game game) {
    Point initPosition = _createFieldPointFrom(data['position']);
    int width = data['width'];
    int height = data['height'];
    int health = data['health'];
    int speed = data['speed'];
    String bulletType = data['bulletType'];
    int direction = data['direction'];
    PlayerTank player = new PlayerTank(initPosition.x,
        initPosition.y,
        width,
        height,
        Directions.values[direction],
        game,
        speed,
        health,
        bulletType);
    return player;
  }

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