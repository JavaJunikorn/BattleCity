import '../moveables/Moveable.dart';
import 'Ground.dart';

class Bush extends Ground{

  static Bush _ground = new Bush._internal();

  Bush._internal():super(true, true, false, "bush");


  static Bush get ground => _ground;

  @override
  void activate(Moveable m) {
    // TODO: implement activate
  }
}