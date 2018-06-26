part of BattleCity;

class Road extends Ground{

  static  Road _ground = new Road._internal();

  Road._internal():super(true, true, false, "road");


  static Road get ground => _ground;

  @override
  void activate(Moveable m) {
    // nothing happens
  }
}