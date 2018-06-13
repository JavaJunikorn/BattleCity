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
import 'dart:js';



void main() {


  Controller controller = new Controller();
  controller.startlevel();
  /*
  LevelLoader.load(0, (level) {
    newGame.level = level;
    testView.update(50);
    direction.startListening();
    newGame.startloop(500);
  });*/

  querySelector(".fullscreen").onTouchEnd.listen((l) {
    fullscreenWorkaround(document.body);
    document.body.onFullscreenChange.listen((i) {
      print("Inside: onFullScreenChange.listen()");
      querySelector(".fullscreen").setAttribute("class", "nav-link btn btn-primary ml-1 fullscreen");
      querySelector(".fa-expand").setAttribute("class", "fa fa-compress");
    });
  });

/*
  window.screen.orientation.onChange.listen(( l) {
    print(window.screen.orientation.type);
  }); */
}


void fullscreenWorkaround(Element element) {
  var elem = new JsObject.fromBrowserObject(element);

  if (elem.hasProperty("requestFullscreen")) {
    elem.callMethod("requestFullscreen");
  }
  else {
    List<String> vendors = ['moz', 'webkit', 'ms', 'o'];
    for (String vendor in vendors) {
      String vendorFullscreen = "${vendor}RequestFullscreen";
      if (vendor == 'moz') {
        vendorFullscreen = "${vendor}RequestFullScreen";
      }
      if (elem.hasProperty(vendorFullscreen)) {
        elem.callMethod(vendorFullscreen);
        return;
      }
    }
  }
}

