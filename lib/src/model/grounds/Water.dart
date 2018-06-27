part of BattleCity;

/**
 * Water is a type of ground.
 * it is not passable or destroyable but it is permeable.
 */
class Water extends Ground{

  //static object which can be accessed from outside
  static Water _ground = new Water._internal();

  /**
   * creates a new Water object
   */
  Water._internal():super(false, true, false, "water");


  static Water get ground => _ground;

  /**
   * when activated nothing happens
   */
  @override
  void activate(Moveable m) {
    //nothing happens
  }
}