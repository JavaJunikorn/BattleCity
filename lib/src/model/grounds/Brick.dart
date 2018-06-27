part of BattleCity;

/**
 * Bricks are a type of ground.
 * they are not passable, permeable but can be destroyed.
 */
class Brick extends Ground {

  //static object which can be accessed from outside
  static final Brick _ground = new Brick._internal();

  static Brick get ground => _ground;

  /**
   * creates a new Brick
   */
  Brick._internal() : super(false, false, true, "brick");

  /**
   * when activated nothing happens
   */
  @override
  void activate(Moveable m) {
    //nothing happens
  }
}
