import '../model/Game.dart';
import '../model/moveables/Moveable.dart';
import 'Controller.dart';
import 'dart:async';
import 'dart:html';

class Listeners {
  Controller controller;
  Point first, last;
  Game game;

  bool _listen = true;
  Listeners(Controller this.controller, Game this.game);

  void _getSwipe() {
    if (last == null || first.distanceTo(last) < 20)
      game.level.player.shoot();
    else {
      Point d = first - last;
      if (d.x.abs() > d.y.abs()) {
        //Waagerecht
        if (first.x > last.x) {
          //links
          game.level.player.changeDirection(Directions.left);
        } else {
          //rechts
          game.level.player.changeDirection(Directions.right);
        }
      } else {
        //Senkrecht
        if (first.y > last.y) {
          //Up
          game.level.player.changeDirection(Directions.up);
        } else {
          //Down
          game.level.player.changeDirection(Directions.down);
        }
      }
    }
  }

  void stopListening(){
        _listen = false;
  }

  void resumeListening(){
    _listen = true;
  }

  void startListening() {
    window.onTouchStart.listen((ev) {
      last = null;
      if(!_listen)return;
      first = ev.touches.first.screen;
    });
    window.onTouchMove.listen((ev) {
      if(!_listen) return;
      last = ev.touches.first.screen;
    });
    window.onTouchEnd.listen((ev) {
      if(!_listen)return;
      _getSwipe();
    });

    window.onKeyDown.listen((k) {
      if(!_listen)return;
      //Shoot
      if (k.keyCode == KeyCode.SPACE) {
        //spacebar
        game.level.player.shoot();
      }
      //Up
      if (k.keyCode == KeyCode.W || k.keyCode == KeyCode.UP) {
        game.level.player.changeDirection(Directions.up);
      }
      //Down
      if (k.keyCode == KeyCode.S || k.keyCode == KeyCode.DOWN) {
        game.level.player.changeDirection(Directions.down);
      }
      //Left
      if (k.keyCode == KeyCode.A || k.keyCode == KeyCode.LEFT) {
        game.level.player.changeDirection(Directions.left);
      }
      //Right
      if (k.keyCode == KeyCode.D || k.keyCode == KeyCode.RIGHT) {
        game.level.player.changeDirection(Directions.right);
      }
    });
  }

  void starMenuListeners() {
    document.getElementById("play").onClick.listen((ev) {
      print("startBtnClicked");
      controller.view.closeMainMenu();
      controller.listeners.startListening();
      controller.startLevel();
    });

    document.getElementById("pause").onClick.listen((ev) {
      controller.view.showPause();
    });

    document.getElementById("controlls").onClick.listen((ev) {
      controller.view.showControlls();
    });

    document.getElementById("help").onClick.listen((ev) {
      controller.view.showTutorial();
    });

    controller.view.modal.nextBtn.onClick.listen((ev) {
      print("nextBtn");
      controller.view.showTutorial();
    });

    document.getElementById("qr").onClick.listen((ev) {
      controller.view.showQrCode();
    });

    controller.view.modal.closeButton.onClick.listen((ev) {
      controller.view.hideControlls();
      controller.view.hideQrCode();
      controller.view.hideTutorial();
      controller.view.hidePause();
    });

    document.getElementById("backToMenuBtn").onClick.listen((e) {
      controller.view.hideLosee();
      controller.mainMenu();
    });
  }

  void stopListeners() {}
}
