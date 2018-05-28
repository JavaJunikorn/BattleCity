import '../model/Game.dart';
import '../model/moveables/Moveable.dart';
import 'dart:html';

class Direction{


  Point first, last;
  Game game;

  void startListening(){


    window.onTouchStart.listen((ev) {
      last = null;
      first = ev.touches.first.client;
    });

    window.onTouchMove.listen((ev){
      last = ev.touches.first.client;
    });

    window.onTouchEnd.listen((ev) {
      if(last == null || first.distanceTo(last) < 20)
        game.player.shoot();
      else {
        Point d = first - last;
        if(d.x.abs() > d.y.abs()){
          //Waagerecht
          if( first.x > last.x){
            //links
            game.player.changeDirection(Directions.left);
          }
          else{
            //rechts
            game.player.changeDirection(Directions.right);
          }
        }
        else{
          //Senkrecht
          if(first.y > last.y){
            //Up
            game.player.changeDirection(Directions.up);
          }
          else{
            //Down
            game.player.changeDirection(Directions.down);

          }
        }
      }
    });


    window.onKeyPress.listen((k) {
      //Shoot
      if(k.which == 32) { //spacebar
        game.player.shoot();
      }
      //Up
      if(k.which == 119 || k.keyCode == KeyCode.UP){
        game.player.changeDirection(Directions.up);
      }
      //Down
      if(k.which == 115 || k.keyCode == KeyCode.DOWN){
        game.player.changeDirection(Directions.down);
      }
      //Left
      if(k.which == 97 || k.keyCode == KeyCode.LEFT){
        game.player.changeDirection(Directions.left);
      }
      //Right
      if(k.which == 100 || k.keyCode == KeyCode.RIGHT){
        game.player.changeDirection(Directions.right);
      }
    });

  }

}