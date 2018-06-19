import '../model/Game.dart';
import '../model/moveables/Moveable.dart';
import 'Controller.dart';
import 'dart:async';
import 'dart:html';

class Listeners {

  Controller controller;
  Point first, last;
  Game game;
  StreamSubscription keyListener;
  StreamSubscription touchstartListener;
  StreamSubscription touchendListener;
  StreamSubscription touchmoveListener;



  Listeners(Controller this.controller, Game this.game);

  void _getSwipe(){

    if(last == null || first.distanceTo(last) < 20)
     game.level.player.shoot();
    else {
      Point d = first - last;
      if(d.x.abs() > d.y.abs()){
        //Waagerecht
        if( first.x > last.x){
          //links
          game.level.player.changeDirection(Directions.left);
        }
        else{
          //rechts
          game.level.player.changeDirection(Directions.right);
        }
      }
      else{
        //Senkrecht
        if(first.y > last.y){
          //Up
          game.level.player.changeDirection(Directions.up);
        }
        else{
          //Down
          game.level.player.changeDirection(Directions.down);
        }
      }
    }
  }

  void startListening(){


   touchstartListener =  window.onTouchStart.listen((ev) {
      last = null;
      first = ev.touches.first.screen;
    });
    touchmoveListener = window.onTouchMove.listen((ev){
      last = ev.touches.first.screen;
    });
    touchendListener = window.onTouchEnd.listen((ev) {
      _getSwipe();
    });


   keyListener =  window.onKeyPress.listen((k) {
      //Shoot
      if(k.which == 32) { //spacebar
        game.level.player.shoot();
      }
      //Up
      if(k.which == 119 || k.keyCode == KeyCode.UP){
        game.level.player.changeDirection(Directions.up);
        print("Up");
      }
      //Down
      if(k.which == 115 || k.keyCode == KeyCode.DOWN){
        game.level.player.changeDirection(Directions.down);
      }
      //Left
      if(k.which == 97 || k.keyCode == KeyCode.LEFT){
        game.level.player.changeDirection(Directions.left);
      }
      //Right
      if(k.which == 100 || k.keyCode == KeyCode.RIGHT){
        game.level.player.changeDirection(Directions.right);
      }
    });


  }

  void starMenuListeners() {
    document.getElementById("play").onClick.listen((ev) {
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
  }


  void stopListeners() {

  }
}