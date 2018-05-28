import 'dart:html';
import 'model/GameField.dart';
import 'model/grounds/Ground.dart';
import 'dart:convert';
import 'lvLoader.dart';
import 'view/View.dart';
import 'model/Game.dart';
import 'model/moveables/PlayerTank.dart';
import 'controller/Direction.dart';
import 'model/grounds/Brick.dart';
import 'model/moveables/EnemyTank.dart';
import 'model/moveables/Moveable.dart';

void main() {

  View testView = null;
  final String path = "../json/lvl1.json" ;
  Game newGame = new Game();
  Direction direction = new Direction();

  newGame.gamefield = new GameField(27, 27);
  testView = new View(newGame);

  HttpRequest.getString(path).then((lvlFromJson) {
    Map data = JSON.decode(lvlFromJson);
    //newGame.gamefield = new GameField(27, 27); //lvlLoader.loadFields(data["gameFields"], 27, 27);
    newGame.gamefield = lvlLoader.loadFields(data["gameFields"], 27, 27);
    newGame.player  = new PlayerTank(25, 13, 2, 2, Directions.right, newGame.gamefield, 2, 10, "");
    EnemyTank enemy1 = new EnemyTank(0, 0, 2, 2, Directions.right, newGame.gamefield, 1, 1, "", "enemy");
    EnemyTank enemy2 = new EnemyTank(0, 4, 2, 2, Directions.right, newGame.gamefield, 1, 1, "", "enemy");


    //testView.toHTMLTable(testView.model);
  });
 // newGame.generateField(1);
 // newGame.gamefield.gameField[3][3].ground = Brick.ground;
 // EnemyTank tank = new EnemyTank(7, 7, 2, 2, Directions.left, newGame.gamefield, 1, 2, "", "player");
  direction.game = newGame;
  direction.startListening();
  newGame.startloop();
  //print(lvlLoader.generateJson(27, 27));
}


List<TableRowElement> toDartTable(String tableBodySelector) {
  var dartTable = querySelector(tableBodySelector) as TableElement;
  return dartTable.rows;
}
