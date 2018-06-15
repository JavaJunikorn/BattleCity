import '../model/Game.dart';
import '../model/moveables/Moveable.dart';
import 'Controller.dart';
import 'dart:async';
import 'dart:html';

class Listeners{

  Controller controller;
  Point first, last;
  Game game;
  StreamSubscription keyListener;
  StreamSubscription touchstartListener;
  StreamSubscription touchendListener;
  StreamSubscription touchmoveListener;
  StreamSubscription touchQrBtnListener;
  StreamSubscription touchHelpBtnListener;
  StreamSubscription touchControllBtnListener;
  StreamSubscription touchPlayBtnListener;

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
    touchQrBtnListener = controller.view.qrButton.onTouchStart.listen((ev) {
      controller.view.showModal(controller.view.qrButton.id);
      controller.view.modal.span.onTouchStart.listen((ev) {
        controller.view.hideModal(controller.view.qrButton.id);
      });
    });
    touchQrBtnListener = controller.view.helpBtn.onTouchStart.listen((ev) {
      controller.view.showModal(controller.view.helpBtn.id);
      controller.view.modal.span.onTouchStart.listen((ev) {
        controller.view.hideModal(controller.view.helpBtn.id);
      });
    });
   touchControllBtnListener = controller.view.controllsBtn.onTouchStart.listen((ev) {
     controller.view.showModal(controller.view.controllsBtn.id);
     controller.view.modal.span.onTouchStart.listen((ev) {
       controller.view.hideModal(controller.view.controllsBtn.id);
     });
   });

   /* TODO:// Zusammen mit Jake überarbeiten
   touchPlayBtnListener = controller.view.playBtn.onTouchStart.listen((l) {
     print("Touched play btn");
     controller.startLevel();
   });
   */

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



  void stopListeners() {

  }
}