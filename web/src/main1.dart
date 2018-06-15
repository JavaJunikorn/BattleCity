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
import 'view/Modal.dart';


void main() {


  Controller controller = new Controller();


  querySelector(".fullscreen").onTouchEnd.listen((l) {
    requestFullscreenOn(document.body);
    document.body.onFullscreenChange.listen((i) {
      print("Inside: onFullScreenChange.listen()");
      querySelector(".fullscreen").setAttribute("class", "nav-link btn btn-primary ml-1 fullscreen");
      querySelector(".fa-expand").setAttribute("class", "fa fa-compress");
    });
  });

}


void requestFullscreenOn(Element element) {
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

