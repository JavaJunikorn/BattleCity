part of BattleCity;


/**
 * the ground and obstacles of the gamefield
 */
abstract class Ground{
   final bool _passable, _permeable, _destroyable;
   final String type;

   /**
    * creates a new ground object
    * @param passable determines if the object can be passed by tanks
    * @param permeable determines if the object can be passed by bullets
    * @param destroyable determines if the object can be destroyed
    */
   Ground(bool this._passable, bool this._permeable, bool this._destroyable, String this.type);


   bool get passable => _passable;

   get permeable => _permeable;

   get destroyable => _destroyable;


   /**
    * when a ground is activated it can do something with the moveable object activating it
    */
   void activate(Moveable m);

   /**
    * returns a groundobject via a type
    * @param groundType the type of ground that shall be returned 
    */
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