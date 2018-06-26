part of BattleCity;

class Barrier extends Ground{

  static Barrier _ground = new Barrier._internal();

  Barrier._internal():super(false, false, false, "barrier");


  static Barrier get ground => _ground;

  @override
  void activate(Moveable m) {
    //nothing happens
  }
}