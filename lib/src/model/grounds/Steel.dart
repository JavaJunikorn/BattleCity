part of BattleCity;

/**
 * Steel is a type of ground.
 * it is not passable, permeable or destroyable.
 */
class Steel extends Ground {

  //static object which can be accessed from outside
  static Steel _ground = new Steel._internal();

  /**
   * creates a new Steel object
   */
  Steel._internal() : super(false, false, false, "steel");


  static Steel get ground => _ground;

  /**
   * when activated nothing happens
   */
  @override
  void activate(Moveable m) {
    //nothing happens
  }
}
