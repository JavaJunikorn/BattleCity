part of BattleCity;

/**
 * Roads are a type of ground.
 * they are  passable and permeable but cannot be destroyed.
 */
class Road extends Ground{

  //static object which can be accessed from outside
  static  Road _ground = new Road._internal();

  /**
   * creates a new Road
   */
  Road._internal():super(true, true, false, "road");


  static Road get ground => _ground;

  /**
   * when activated nothing happens
   */
  @override
  void activate(Moveable m) {
    // nothing happens
  }
}