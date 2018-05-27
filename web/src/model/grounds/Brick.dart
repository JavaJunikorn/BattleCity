import 'Ground.dart';
import '../moveables/Moveable.dart';

class Brick extends Ground {
  static final Brick _ground = new Brick._internal();

  static Brick get ground => _ground;

  Brick._internal() : super(false, false, true, "brick");

  @override
  void activate(Moveable m) {
    //nothing happens
  }
}
