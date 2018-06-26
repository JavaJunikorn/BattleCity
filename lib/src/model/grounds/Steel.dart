part of BattleCity;

class Steel extends Ground {
  static Steel _ground = new Steel._internal();

  Steel._internal() : super(false, false, false, "steel");


  static Steel get ground => _ground;

  @override
  void activate(Moveable m) {
    //nothing happens
  }
}
