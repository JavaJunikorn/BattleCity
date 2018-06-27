part of BattleCity;

/**
 * Barriers are a type of ground.
 * they are not passable, permeable or destroyable.
 */
class Barrier extends Ground{

  //static object which can be accessed from outside
  static Barrier _ground = new Barrier._internal();

  /**
   * creates a new Barrier
   */
  Barrier._internal():super(false, false, false, "barrier");


  static Barrier get ground => _ground;

  /**
   * when activated nothing happens
   */
  @override
  void activate(Moveable m) {
    //nothing happens
  }
}