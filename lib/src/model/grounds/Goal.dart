part of BattleCity;

/**
 * Goals are a type of ground.
 * they are not passable or permeable but can be destroyed.
 */
class Goal extends Ground{

  //static object which can be accessed from outside
  static final Goal _ground = new Goal._internal();

  static Goal get ground => _ground;

  /**
   * creates a new Goal
   */
  Goal._internal():super(false, false, true, "goal");

  /**
   * when activated nothing happens
   */
  @override
  void activate(Moveable m) {
  //nothing happens
  }
}