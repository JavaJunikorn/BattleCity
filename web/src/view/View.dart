import '../controller/Controller.dart';
import 'dart:html';
import 'dart:async';
import '../model/Game.dart';
import '../model/moveables/Moveable.dart';
import '../controller/Direction.dart';
import '../model/moveables/Tank.dart';

class View {
  Game model;
  Controller controller;
  Element htmlTable;
  List<Element> rows;
  List<Element> cols;

  View(Game this.model, Controller this.controller);

 

  TableElement toHTMLTable(Game game) {
    TableElement table = new TableElement();
    //table.setAttribute("class", "table");
    var tBody = table.createTBody();

    for (int i = 0; i < game.level.gamefield.height; i++) {
      tBody.insertRow(i);
      for (int j = 0; j < game.level.gamefield.width; j++) {
        tBody.rows.elementAt(i).insertCell(j);
        tBody.rows.elementAt(i).cells.elementAt(j).setAttribute("class",
            "bg-" + game.level.gamefield.gameField[i + 1][j + 1].ground.type);
      }
    }

    for (int i = 0; i < game.level.gamefield.moveables.length; i++) {
      tBody.rows
          .elementAt(game.level.gamefield.moveables[i].positions[0][0].y)
          .cells
          .elementAt(game.level.gamefield.moveables[i].positions[0][0].x)
          .setAttribute(
              "class", "bg-" + game.level.gamefield.moveables[i].type);
    }

    return table;
  }

  void setElement(Point destination) {}

  void update(int delay) {
    querySelector(".main-container").children.clear();
    querySelector(".main-container").children.add(toHTMLTable(model));
    new Timer.periodic(new Duration(milliseconds: delay), (t) {
      htmlTable =
          querySelector(".main-container").children.first.children.first;
      rows = htmlTable.children;
      for (int i = 0; i < rows.length; i++) {
        cols = rows[i].children;
        for (int j = 0; j < cols.length; j++) {
          cols[j].setAttribute(
              "class",
              "bg-" +
                  model.level.gamefield.gameField[i + 1][j + 1].ground.type);
        }
      }

      updateHint();
      model.level.gamefield.moveables.forEach((m) {
        StringBuffer buffer = new StringBuffer("bg-");
        buffer.write(
            model.level.gamefield.getField(m.positions[0][0]).ground.type);
        buffer.write(" bg-");
        buffer.write(m.type);
        buffer.write("-");
        buffer.write(Moveable.directionOf(m));
        buffer.write("-");
        buffer.write(m.getLevel());
        try {
          var field = rows[m.positions[0][0].y]
              .children[m.positions[0][0].x];
          field.setAttribute("class", buffer.toString());
        } catch (e) {}
      });
    });
  }

  void setAttributeTo(Point destination, String name, String value) {
    rows
        .elementAt(destination.y)
        .children
        .elementAt(destination.x)
        .setAttribute(name, value);
  }

  void updateHint() {
    Point playerTankPos = model.level.player.positions[0][0];
    if ((playerTankPos.x == 14 && playerTankPos.y == 25) ||
        (playerTankPos.x == 6 && playerTankPos.y == 25)) {
      querySelector(".speech-bubble").text =
          "Wische von unten nach oben um den Panzer nach oben zu bewegen";
      ImageElement img = querySelector(".swipe").children.first as ImageElement;
      img.src = "../img/swipe-to-up.png";
      querySelector(".swipe").setAttribute("class", "swipe swipe-up");
    } else if (model.level.player.positions[0][0].x == 25 &&
        model.level.player.positions[0][0].y == 14) {
      querySelector(".speech-bubble").text =
          "Wische von rechts nach links um den Panzer nach links zu bewegen";
      ImageElement img = querySelector(".swipe").children.first as ImageElement;
      img.src = "../img/swipe-to-left.png";
      querySelector(".swipe").setAttribute("class", "swipe swipe-left");
    } else if ((playerTankPos.x == 18 && playerTankPos.y == 23) ||
        (playerTankPos.x == 10 && playerTankPos.y == 23)) {
      querySelector(".speech-bubble").text =
          "Wische von oben nach unten um den Panzer nach unten zu bewegen";
      ImageElement img = querySelector(".swipe").children.first as ImageElement;
      img.src = "../img/swipe-to-down.png";
      querySelector(".swipe").setAttribute("class", "swipe swipe-down");
    } else if ((playerTankPos.x == 6 && playerTankPos.y == 23) ||
        (playerTankPos.x == 14 && playerTankPos.y == 23) ||
        (playerTankPos.x == 18 && playerTankPos.y == 25)) {
      querySelector(".speech-bubble").text =
          "Wische von links nach rechts um den Panzer nach rechts zu bewegen";
      ImageElement img = querySelector(".swipe").children.first as ImageElement;
      img.src = "../img/swipe-to-right.png";
      querySelector(".swipe").setAttribute("class", "swipe swipe-right");
    }
  }

  void showCongrats() {
    //Todo showCongrats
    //Todo addListeners
  }

  static void showCredits() {
    //Todo showCredits
    //Todo addListeners
  }

  void showMainMenu() {
    ButtonElement button = new ButtonElement();
    button.setInnerHtml("start");
     var l;
     l = button.onClick.listen((e){
      controller.startLevel();
    });
    querySelector(".main-container").children.add(button);
    //Todo showMenu
  }

  void showLose() {
    //Todo show menue

    querySelector("------back to menu button-----").onClick.listen((e){
      controller.mainMenu();
    });
  }

  void showLoading() {
   querySelector(".main-container").children.clear();
   ButtonElement button = new ButtonElement();
   button.setInnerHtml("next Level");
   button.onClick.listen((e){

   });
   querySelector(".main-container").children.add(button);
  }
  
  
}
