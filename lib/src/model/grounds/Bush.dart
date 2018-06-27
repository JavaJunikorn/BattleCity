part of BattleCity;

/**
 * Bushed are a type of ground.
 * they are passable and permeable but cannot be destroyed
 */
class Bush extends Ground{

  //static object which can be accessed from outside
  static Bush _ground = new Bush._internal();

  /**
   * creates a new Bush
   */
  Bush._internal():super(true, true, false, "bush");


  static Bush get ground => _ground;

  /**
   * when activated nothing happens
   */
  @override
  void activate(Moveable m) {
  }
}