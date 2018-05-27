import 'dart:math';
import 'model/GameField.dart';
import 'model/grounds/Ground.dart';

class lvlLoader {


  static GameField loadFields(List<Map> data, int rows, cols) {
    GameField game = new GameField(rows, cols);

    data.forEach((dimension) {
      String type = dimension["type"];
      Point pointFromMap = _createFieldPointFrom(dimension["position"]);

      game.setGround(pointFromMap, type);
    });
    return game;

      /*
      switch(type) {
        case "road":
          game.setGroundType(pointFromMap, Gr);
          break;
        case "brick":
          game.setGroundType(pointFromMap, Ground.BRICK);
          break;
        case "water":
          game.setGroundType(pointFromMap, Ground.WATER);
          break;
        case "steel":
          game.setGroundType(pointFromMap, Ground.STEEL);
          break;
        case "base":
          game.setGroundType(pointFromMap, Ground.BASE);
          break;
        case "barrier":
          game.setGroundType(pointFromMap, Ground.BARRIER);
          break;
        case "bush":
          game.setGroundType(pointFromMap, Ground.BUSH);
          break;
      }
    });*/
  }

  static Point _createFieldPointFrom(Map data) => new Point(data["row"], data["col"]);

  static String _generateJson(int rows, int cols) {
    String json="{"
        "\"level\": 1,"
        "\"gameFields\": [";
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        json += "{\"point\": {\"row\":" + i.toString() + ",";
        json += "\"col\": " + j.toString() + "},";
        json += "\"type\": \"\"";
        if (i.compareTo(rows-1) == 0 && j.compareTo(cols - 1) == 0) {
          json += "}]}";
        } else
          json += "},";
      }
    }
  }
}