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

import 'view/ModalElement.dart';


void main() {


  Controller controller = new Controller();
  //ModalElement m = new ModalElement.created();
  //document.getElementById("modalWrapper").children.add(m.modalWrapper);


  /*
  print(new Point(1, 1) == new Point(1, 1));
  querySelector(".fullscreen").onTouchEnd.listen((l) {
    requestFullscreenOn(document.body);
    document.body.onFullscreenChange.listen((i) {
      print("Inside: onFullScreenChange.listen()");
      querySelector(".fullscreen").setAttribute("class", "nav-link btn btn-primary ml-1 fullscreen");
      querySelector(".fa-expand").setAttribute("class", "fa fa-compress");
    });
  });*/

}




