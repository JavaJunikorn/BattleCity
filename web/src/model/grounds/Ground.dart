import '../moveables/Moveable.dart';
import 'Barrier.dart';
import 'Bush.dart';
import 'Goal.dart';
import 'Road.dart';
import 'Steel.dart';
import 'Water.dart';
import 'Brick.dart';

abstract class Ground{
   final bool _passable, _permeable, _destroyable;
   final String type;

  //durchfahrbar, durchlässig, zerstörbar

   Ground(bool this._passable, bool this._permeable, bool this._destroyable, String this.type);

   bool get passable => _passable;

   get permeable => _permeable;

   get destroyable => _destroyable;


   void activate(Moveable m);

   factory Ground.factory(String groundType){
     Ground g;
     switch (groundType){
       case "bush":{
         g = Bush.ground;
         break;
       }
       case "barrier":{
         g = Barrier.ground;
         break;
       }
       case "road":{
         g = Road.ground;
         break;
       }
       case "steel":{
         g = Steel.ground;
         break;
       }
       case "water":{
         g = Water.ground;
         break;
       }
       case "goal":{
         g = Goal.ground;
         break;
       }
       case "brick": {
         g = Brick.ground;
         break;
       }
       default:
         g = Road.ground;
     }
     return g;
   }

}