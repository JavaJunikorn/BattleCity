import '../model/Game.dart';
import '../model/moveables/Moveable.dart';
import 'dart:html';

class Direction{


  Point first, last;
  Game game;
  static Point lastDirection;

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

          //Jenia: last direction is left
          lastDirection = Moveable.LEFT;
        }
        else{
          //rechts
          game.level.player.changeDirection(Directions.right);

          //Jenia: last direction is right
          lastDirection = Moveable.RIGHT;
        }
      }
      else{
        //Senkrecht
        if(first.y > last.y){
          //Up
          game.level.player.changeDirection(Directions.up);


          //Jenia: last direction is up
          lastDirection = Moveable.UP;
        }
        else{
          //Down
          game.level.player.changeDirection(Directions.down);

          //Jenia: last direction is down
          lastDirection = Moveable.DOWN;
        }
      }
    }
  }

  void startListening(){


    window.onTouchStart.listen((ev) {
      last = null;
    //  print("start");
      first = ev.touches.first.screen;
    });

    window.onTouchMove.listen((ev){
      last = ev.touches.first.screen;
    // print(last.toString());
    });

    window.onTouchEnd.listen((ev) {
     // print("End");
      _getSwipe();
    });


    window.onKeyPress.listen((k) {
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

}