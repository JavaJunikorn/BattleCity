import '../model/Game.dart';
import '../view/View.dart';
import 'Direction.dart';

class Controller {
  Game game;
  View view;
  Direction direction;

  Controller() {
    game = new Game();
    game.loadMeta().whenComplete((){
      view = new View(game);
      direction = new Direction();
      direction.game = game;
    });

  }

  void startlevel() {
    game.startloop().whenComplete(() {
      view.update(10);
      direction.startListening();
    });
  }
}
