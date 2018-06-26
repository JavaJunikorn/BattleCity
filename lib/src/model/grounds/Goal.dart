part of BattleCity;

class Goal extends Ground{
  static final Goal _ground = new Goal._internal();

  static Goal get ground => _ground;

  Goal._internal():super(false, false, true, "goal");

  @override
  void activate(Moveable m) {
  //nothing happens
  }
}