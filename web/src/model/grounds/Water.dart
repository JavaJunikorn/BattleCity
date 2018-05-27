import '../moveables/Moveable.dart';
import 'Ground.dart';

class Water extends Ground{

  static Water _ground = new Water._internal();

  Water._internal():super(false, true, false, "water");


  static Water get ground => _ground;

  @override
  void activate(Moveable m) {
    // TODO: implement activate
  }
}