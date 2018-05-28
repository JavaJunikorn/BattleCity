import 'dart:html';
import 'dart:async';
import '../model/Game.dart';

class View {

  Game model;

  View (Game this.model){
    querySelector(".col-12").children.add(toHTMLTable(model));
    new Timer.periodic(new Duration(milliseconds: 2000), (t){
      TableElement t = toHTMLTable(model);
      //querySelector(".col-12").children.clear();
//      querySelector(".col-12").children.add(toHTMLTable(model));
       Element table = querySelector(".col-12").children.first.children.first;
       List<Element> rows = table.children;
       for(int i = 0; i < rows.length; i++){
         List<Element> cols = rows[i].children;
         for(int j = 0; j < cols.length; j++){
           cols[j].setAttribute("class", "bg-" + model.gamefield.gameField[i+1][j+1].ground.type);
         }
       }

       model.gamefield.moveables.forEach((m){
         rows[m.positions[0][0].y].children[m.positions[0][0].x].setAttribute("class", "bg-" + m.type);
       });

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