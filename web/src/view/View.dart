import '../model/GameField.dart';
import 'dart:html';
import 'dart:async';
import '../model/grounds/Road.dart';
import '../model/grounds/Brick.dart';
import '../model/grounds/Water.dart';
import '../model/grounds/Bush.dart';
import '../model/grounds/Steel.dart';
import '../model/grounds/Barrier.dart';
import '../model/grounds/Goal.dart';
import '../model/Game.dart';

class View {

  Game model;

  View (Game this.model){

    new Timer.periodic(new Duration(milliseconds: 200), (t){
      querySelector(".col-12").children.clear();
      querySelector(".col-12").children.add(toHTMLTable(model));
    });


  }



  TableElement toHTMLTable(Game game) {
    TableElement table = new TableElement();
    var tBody = table.createTBody();
    for (int i = 0; i < game.gamefield.height; i++) {
      tBody.insertRow(i);
      for (int j = 0; j < game.gamefield.width; j++) {
        tBody.rows.elementAt(i).insertCell(j);
        tBody.rows.elementAt(i).cells.elementAt(j).setAttribute("class", "bg-" + game.gamefield.gameField[i+1][j+1].ground.type);
      }
    }
    for(int i = 0; i < game.gamefield.moveables.length; i++){
      tBody.rows.elementAt(game.gamefield.moveables[i].positions[0][0].y).cells.elementAt(game.gamefield.moveables[i].positions[0][0].x).setAttribute("class", "bg-" + game.gamefield.moveables[i].type);
    }
    return table;
  }

  void setElement(Point destination) {

  }
}