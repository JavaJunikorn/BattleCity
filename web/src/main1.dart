import 'dart:html';
import 'dart:convert';
import 'view/View.dart';
import 'model/Game.dart';
import 'controller/Direction.dart';
import 'model/moveables/PlayerTank.dart';
import 'model/moveables/Moveable.dart';
import 'model/GameField.dart';
import 'Level.dart';
import 'LevelLoader.dart';
import 'dart:async';
import 'controller/Controller.dart';



void main() {


  Controller controller = new Controller();

  /*
  LevelLoader.load(0, (level) {
    newGame.level = level;
    testView.update(50);
    direction.startListening();
    newGame.startloop(500);
  });*/

}


