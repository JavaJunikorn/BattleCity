import '../controller/Controller.dart';
import 'dart:html';
import 'dart:async';
import '../model/Game.dart';
import '../model/moveables/Moveable.dart';
import '../controller/Listeners.dart';
import '../model/moveables/Tank.dart';
import 'ModalElement.dart';
import 'dart:js';


class View {
  Game model;
  Controller controller;
  Element htmlTable;
  ModalElement modal;
  List<Element> rows;
  List<Element> cols;
  var tutorialPart = 0;
  var tutorialSubgoals = [
    new Point(0, 25), new Point(6, 25),
    new Point(21, 17), new Point(25, 9),
    new Point(4, 5), new Point(12, 5)
  ];
  var speechText = [
    "Willcomen in Battle City. In diesem Tutoriallevel lernst du die Gundlagen des Spiels."
    "Du kannst jederzeit die Steuerungs Hilfe mit der Taste (<i class=\"fa fa-gamepad\"></i>) abrufen."
    "Die Inhalte dieses Tutorials und mehr Info zum Spiel findest du unter der Taste (<i class=\"fa fa-question\"></i>).",

    "Perfekt!</br> "
    "Jetzt hast Stahlhindernis (<img src=\"../img/fields/bg-steel-field.png\">) vor dir!"
    "Sie ist nicht zestörbard, durchfahrbar oder kugeldurchlässig!"
    "Überhole sie und bewege dich zum nächsten Ziel!",

    "Perfekt!</br> "
    "Link vor dir ligt ein Wasserhindernis (<img src=\"../img/fields/bg-water-field.png\">)!"
    "Sie ist nicht zestörbard oder durchfahrbar, aberkugeldurchlässig (d.h, dass die Kugeln über"
    " das Wasser fliegen können."
    "Überhole sie und bewege dich zum nächsten Ziel!",


    "Du hast Busch vor dir",

    "Du hast Brick vor dir",

    "Hinter dem Brick ist..."
  ];


  View(Game this.model, Controller this.controller) {
    modal = new ModalElement.created();
  }

 

  TableElement toHTMLTable(Game game) {
    var table = new TableElement();
    var tBody = table.createTBody();

    for (int i = 0; i < game.level.gamefield.height; i++) {
      tBody.insertRow(i);
      for (int j = 0; j < game.level.gamefield.width; j++) {
        tBody.rows.elementAt(i).insertCell(j);
        tBody.rows.elementAt(i).cells.elementAt(j).setAttribute("class",
            "bg-" + game.level.gamefield.gameField[i + 1][j + 1].ground.type);
      }
    }

    for (int i = 0; i < game.level.gamefield.moveables.length; i++) {
      tBody.rows
          .elementAt(game.level.gamefield.moveables[i].positions[0][0].y)
          .cells
          .elementAt(game.level.gamefield.moveables[i].positions[0][0].x)
          .setAttribute(
              "class", "bg-" + game.level.gamefield.moveables[i].type);
    }

    table.setAttribute("class", "bg-black");
    return table;
  }


  void update(int delay) {
    querySelector(".main-container").children.clear();
    _resetSpeech();
    querySelector(".main-container").children.add(toHTMLTable(model));
    new Timer.periodic(new Duration(milliseconds: delay), (t) {
      htmlTable =
          querySelector(".main-container").children.first.children.first;
      rows = htmlTable.children;
      for (int i = 0; i < rows.length; i++) {
        cols = rows[i].children;
        for (int j = 0; j < cols.length; j++) {
          cols[j].setAttribute("class", "bg-" +
                  model.level.gamefield.gameField[i + 1][j + 1].ground.type);
        }
      }
      if (model.currentLevel == 0 && tutorialSubgoals.length != 0) {
        updateTutorialSpeech();
      } else {
        updateLevelStatSpeech();
      }

      model.level.gamefield.moveables.forEach((m) {
        StringBuffer buffer = new StringBuffer("bg-");
        buffer.write(
            model.level.gamefield.getField(m.positions[0][0]).ground.type);
        buffer.write(" bg-");
        buffer.write(m.type);
        buffer.write("-");
        buffer.write(Moveable.directionOf(m));
        buffer.write("-");
        buffer.write(m.getLevel());
        try {
          var field = rows[m.positions[0][0].y]
              .children[m.positions[0][0].x];
          field.setAttribute("class", buffer.toString());
        } catch (e) {}
      });
    });
  }

  void setAttributeTo(Point destination, String name, String value) {
    rows
        .elementAt(destination.y)
        .children
        .elementAt(destination.x)
        .setAttribute(name, value);
  }

  void updateTutorialSpeech() {
    Point playerPos = model.level.player.positions[0][0];

    if (tutorialSubgoals.length == 0)
      return;

    if (playerPos == tutorialSubgoals[0] && tutorialSubgoals.length == 6) {
      document.getElementById("speech").innerHtml = speechText[0];
      tutorialSubgoals.removeAt(0);
      speechText.removeAt(0);
      return;
    }

    if (playerPos == tutorialSubgoals[0] && tutorialSubgoals.length == 5) {
      document.getElementById("speech").innerHtml = speechText[0];
      tutorialSubgoals.removeAt(0);
      speechText.removeAt(0);
      return;
    }
    if (playerPos == tutorialSubgoals[0] && tutorialSubgoals.length == 4) {
      document.getElementById("speech").innerHtml= speechText[0];
      tutorialSubgoals.removeAt(0);
      speechText.removeAt(0);
      return;
    }
    if (playerPos == tutorialSubgoals[0] && tutorialSubgoals.length == 3) {
      document.getElementById("speech").innerHtml = speechText[0];
      tutorialSubgoals.removeAt(0);
      speechText.removeAt(0);
      return;
    }
    if (playerPos == tutorialSubgoals[0] && tutorialSubgoals.length == 2) {
      document.getElementById("speech").innerHtml = speechText[0];
      tutorialSubgoals.removeAt(0);
      speechText.removeAt(0);
      return;
    }
    higlightTutorialSubgoal(tutorialSubgoals[0]);
  }

  void higlightTutorialSubgoal(Point postion) {
    rows[postion.y].children.elementAt(postion.x).setAttribute("class", "bg-road invalid");
    rows[postion.y].children.elementAt(postion.x + 1).setAttribute("class", "bg-road invalid");
    rows[postion.y + 1].children.elementAt(postion.x).setAttribute("class", "bg-road invalid");
    rows[postion.y + 1].children.elementAt(postion.x + 1).setAttribute("class", "bg-road invalid");

  }

  void updateLevelStatSpeech() {
    document.getElementById("speech").children.clear();
    document.getElementById("speech").text = "Lebenspunkte:";
    document.getElementById("speech").style.fontSize = "2vh";
    for (int i = 0; i < model.level.player.health; i++) {
      var  health = new SpanElement();
      health.setAttribute("class", "fa fa-heart");
      health.style.paddingLeft = "1vh";
      document.getElementById("speech").children.add(health);
    }

    document.getElementById("enemiesStat").children.clear();
    document.getElementById("enemiesStat").text = "Verbliebende Gegner: ";
    document.getElementById("enemiesStat").style.fontSize = "2vh";
    for (int i = 0; i < model.level.gamefield.enemyCount; i++) {
      var  enemy = new ImageElement();
      enemy.src = "../img/etc/enemy-stat.png";
      enemy.style.paddingLeft = "1vh";
      enemy.style.width = "4vh";
      document.getElementById("enemiesStat").children.add(enemy);
    }
  }


  void _resetSpeech() {
    document.getElementById("speech").children.clear();
    document.getElementById("enemiesStat").children.clear();
  }

  void showCongrats() {
    //Todo showCongrats
    //Todo addListeners
  }

  static void showCredits() {
    //Todo showCredits
    //Todo addListeners
  }

//////////////////////////////////////////////////////
//  Main menu
/////////////////////////////////////////////////////

  void showMainMenu() {
    var logo = new ImageElement();
    logo.src = "../img/brand/battle-city-logo.png";
    logo.style.width = "100%";

    var startMenu = new UListElement();
    var playButton = new LIElement();

    playButton.id = "play";
    playButton.innerHtml = "<i class='fa fa-hand-o-right'></i> Start game!";

    startMenu.children.add(playButton);

    modal.setModalbodyChildren(startMenu);

    modal.modalHeader.style.padding = "4vh";
    modal.modalHeader.children.add(logo);


    modal.modalWrapper.style.backgroundColor = "orange";
    modal.modalWrapper.setAttribute("class", "modal bg-img");

    modal.hideCloseButton();

    modal.showModal();

  }

  void closeMainMenu() {
    modal.modalHeader.children.removeLast();
    modal.hideModal();
  }


//////////////////////////////////////////////////////////
// Menuleiste
//////////////////////////////////////////////////////////

  void showPause() {
    modal.modalHeading.text = "Das Spiel ist pausiert";
    modal.modalBody.text = "Auch der Panzerfahrer braucht ab und zu Pausen ;)";
    document.getElementById("pause").children.first.setAttribute("class", "nav-link btn btn-primary ml-1");

    modal.showCloseButton();
    modal.showHeading();
    modal.showModal();
  }

  void hidePause() {
    document.getElementById("pause").children.first.setAttribute("class", "nav-link btn btn-secondary ml-1");

    modal.hideModal();
  }


  void showControlls() {
    modal.modalHeading.text = "Hilfe: Steuerung";
    modal.showHeading();
    modal.showCloseButton();
    document.getElementById("controlls").children.first.setAttribute("class", "nav-link btn btn-primary ml-1");

    var text =  [
      "Nach rechts bewegen",
      "Nach unten bewegen",
      "Nach links bewegen",
      "Nach oben bewegen"
    ];

    var swipesTable = _generateTable(4, 2);
    swipesTable.id = "swipesTable";

    for (int i = 0; i < 4; i++) {
      var animationDiv = new DivElement();
      var swipeDirectionImg = new ImageElement();

      animationDiv.setAttribute("class", "swipe-animation-$i");
      swipeDirectionImg.src = "../img/swipes/swipe$i.png";
      swipeDirectionImg.style.width = "5vh";

      animationDiv.children.add(swipeDirectionImg);

      swipesTable.rows.elementAt(i).cells.elementAt(0).text = text[i];
      swipesTable.rows.elementAt(i).cells.elementAt(1).children.add(animationDiv);
    }


    modal.modalBody.children.add(swipesTable);

    modal.showCloseButton();
    modal.showModal();
  }
  
  void hideControlls() {
    document.getElementById("controlls").children.first.setAttribute("class", "nav-link btn btn-secondary ml-1");
    modal.hideModal();
  }


  void showQrCode() {
    modal.modalHeading.text = "Teile unser spiel mit!";
    document.getElementById("qr").children.first.setAttribute("class", "nav-link btn btn-primary ml-1");

    var img = new ImageElement();
    img.src = "../img/qr.svg";

    modal.modalBody.children.add(img);
    modal.showCloseButton();
    modal.showModal();
  }

  void hideQrCode() {
    document.getElementById("qr").children.first.setAttribute("class", "nav-link btn btn-secondary ml-1");
    modal.hideModal();
  }


  void showTutorial() {
    modal.resetModal();
    switch (tutorialPart) {
      case 0:
        document.getElementById("help").children.first.setAttribute("class", "nav-link btn btn-primary ml-1");
        _loadFirstHelpPart();
        tutorialPart++;
        break;
      case 1:
        _loadSecondHelpPart();
        tutorialPart++;
        print("Tutorial part  = $tutorialPart");
        break;
      case 2:
        _loadThirdHelpPart();
        tutorialPart++;
        break;
      case 3:
        _loadFirthHelpPart();
        tutorialPart++;
        break;
      case 4:
        _loadFifthHelpPart();
        tutorialPart = 0;
    }
    modal.showHeading();
    modal.showCloseButton();
    modal.showModalFooter();
    modal.nextBtn.style.display = "block";
    modal.showModal();
  }

  void _loadFirstHelpPart() {
    var text = new Element.p();

    modal.modalHeading.text = "Anleitung (1/5): Info zum Spiel";

    text.innerHtml = "Battle city beinhaltet zurzeit 7 level (inklusive Tutorial). "
        "Die Level stellen Schlachtfelder aus der Vogelperspektive dar und "
        "enthalten immer folgende Elemente: Das Hauptquartier, den eigenen Panzer, "
        "feindliche Panzer und Hindernisse, wie z.B. Mauern oder Wasserflächen. "
        "Das Hauptquartier, symbolisiert durch einen Wappenadler, befindet sich "
        "mittig am unteren Bildschirmrand und ist von einer Schutzmauer umgeben. "
        "Wird diese Mauer durch gegnerische oder eigene Schüsse zerstört und der "
        "Adler getroffen, geht das Spiel verloren. Verliert der Spieler alle Leben, "
        "führt dies ebenfalls zum Spielende. Die Steuerungshilfe (<i class='fa fa-gamepad'></i>) und "
        "diese Anleitung (<i class='fa fa-question'></i>) kannst du dir zu jeder Zeit anzeigen lassen";

    text.style.textAlign = "justify";
    text.style.fontSize = "2vh";
    modal.modalContent.style.width = "95%";
    modal.modalBody.children.add(text);

  }

  void _loadSecondHelpPart() {
    modal.modalHeading.text = "Anleitung (2/5): Feldertypen";

    var fieldsTable = _generateTable(6, 2, "fieldTypes");
    var imgNames = [ "road", "brick", "bush", "water", "steel", "goal"];
    var groundProperties = [
      ["durchfahrbar", "durchlässig", "nicht zerstörbar"],
      ["nicht durchfahrbar", "nicht durchlässig", "zerstörbar"],
      ["durchfahrbar", "durchlässig",  "nicht zerstörbar"],
      ["nicht durchfahrbar", "durchlässig", "zerstörbar"],
      ["nicht durchfahrbar", "nicht durchlässig", "nicht zerstörbar"],
      ["nicht durchfahrbar", "nicht durchlässig", "zerstörbar"]
    ];

    for (int i = 0; i < 6; i++) {
      var bgFieldImg = new ImageElement();
      var fieldProperties = _generateList(groundProperties[i]);

      bgFieldImg.src = "../img/fields/bg-" + imgNames[i] +"-field.png";
      bgFieldImg.setAttribute("class", "tutorial-img-sm");


      fieldsTable.rows.elementAt(i).cells.elementAt(0).setAttribute("class", "text-center");

      fieldsTable.rows.elementAt(i).cells.elementAt(0).children.add(bgFieldImg);
      fieldsTable.rows.elementAt(i).cells.elementAt(1).children.add(fieldProperties);
    }


    modal.modalBody.children.add(fieldsTable);
  }

  void _loadThirdHelpPart() {
    var text = new Element.p();

    modal.modalHeading.text = "Anleitung (3/5): Gegner und level";

    text.text = "Die Gegner erscheinen auf dem Spielfeld an drei in Level definierten Plätzen. "
        "Mit fortschreitendem Spielverlauf kämpft der Spieler gegen schnellere und "
        "besser gepanzerte Feindpanzer (insgesamt vier Typen) und manövriert an unterschiedlichen "
        "Hindernissen wie Backstein- und Stahlmauern oder Gewässern vorbei bzw. zerschießt sie. "
        "Je nach Level variiert die Menge der jeweiligen Panzertypen. Viel Erfolg auf dem Schlachtfeld!";

    text.style.textAlign = "justify";
    text.style.fontSize = "2vh";
    modal.modalBody.children.add(text);
  }

  void _loadFirthHelpPart() {
    modal.modalHeading.text = "Anleitung (4/5): Panzertypen";

    var enemiesTable = _generateTable(4, 2, "enemyTypes");
    var enemyNames = [ "easyEnemy", "medEnemy", "strongEnemy", "veryStrongEnemy"];
    var enemyProperties = [
      ["Gesundheit: ", "Geschwindigkeit: ", "Kugelschaden: ", "Punkte: "],
      ["Gesundheit: ", "Geschwindigkeit: ", "Kugelschaden: ", "Punkte: "],
      ["Gesundheit: ", "Geschwindigkeit: ", "Kugelschaden: ", "Punkte: "],
      ["Gesundheit: ", "Geschwindigkeit: ", "Kugelschaden: ", "Punkte: "],
    ];

    var easyEnemy = new ImageElement();
    var medEnemy = new ImageElement();
    var strongEnemy = new ImageElement();
    var veryStrongEnemy = new ImageElement();

    easyEnemy.src = "../img/moveables/bg-easyEnemy-right-1.png";
    medEnemy.src = "../img/moveables/bg-medEnemy-right-1.png";
    strongEnemy.src = "../img/moveables/bg-strongEnemy-right-1.png";
    veryStrongEnemy.src = "../img/moveables/bg-veryStrongEnemy-right-1.png";

    for (int i = 0; i < enemyNames.length; i++) {
      var enemyImg = new ImageElement();
      var fieldProperties = _generateList(enemyProperties[i]);

      enemyImg.src = "../img/moveables/bg-" + enemyNames[i] +"-right-1.png";
      enemyImg.setAttribute("class", "tutorial-img-sm");


      enemiesTable.rows.elementAt(i).cells.elementAt(0).setAttribute("class", "text-center");

      enemiesTable.rows.elementAt(i).cells.elementAt(0).children.add(enemyImg);
      enemiesTable.rows.elementAt(i).cells.elementAt(1).children.add(fieldProperties);
    }


    modal.modalBody.children.add(enemiesTable);
  }

  void _loadFifthHelpPart() {
    var text = new Element.p();

    modal.modalHeading.text = "Anleitung (5/5): Punkten und letzte Level";

    text.text = "Nach Abschluss jeder Stage werden die zerstörten Panzer aufgezählt "
        "und die Punktzahl errechnet. Wird das letzte Level erfolgreich abgeschlossen, "
        "erscheint dann Hauptmenü.";

    text.style.textAlign = "justify";
    text.style.fontSize = "2vh";
    modal.modalBody.children.add(text);
  }

  void hideTutorial() {
    tutorialPart = 0;
    document.getElementById("help").children.first.setAttribute("class", "nav-link btn btn-secondary ml-1");
    modal.hideFooter();
  }

  void showLose() {

    var loseImg = new ImageElement();
    loseImg.src = "../img/etc/lose-banner.png";
    loseImg.style.width = "100%";

    modal.setModalbodyChildren(loseImg);
    modal.hideHeader();
    modal.showModalFooter();
    modal.backToMenuBtn.style.display = "block";
    modal.showModal();
  }

  void hideLosee() {
    modal.hideModal();
  }

  void showLoading() {
   querySelector(".main-container").children.clear();
   ButtonElement button = new ButtonElement();
   button.setInnerHtml("next Level");
   button.onClick.listen((e){

   });
   querySelector(".main-container").children.add(button);
  }



  void updateLevelCount() {
    int levelNr = model.currentLevel;
    document.getElementById("levelNr").text = "level $levelNr";
  }

  void requestFullscreenOn(Element element) {
    var elem = new JsObject.fromBrowserObject(element);

    if (elem.hasProperty("requestFullscreen")) {
      elem.callMethod("requestFullscreen");
    }
    else {
      List<String> vendors = ['moz', 'webkit', 'ms', 'o'];
      for (String vendor in vendors) {
        String vendorFullscreen = "${vendor}RequestFullscreen";
        if (vendor == 'moz') {
          vendorFullscreen = "${vendor}RequestFullScreen";
        }
        if (elem.hasProperty(vendorFullscreen)) {
          elem.callMethod(vendorFullscreen);
          return;
        }
      }
    }
  }



  TableElement _generateTable(int row, int col, [String id]) {
    var table = new TableElement();
    var tBody = table.createTBody();


    for (int i = 0; i < row; i++) {
      tBody.insertRow(i);
      for (int j = 0; j < col; j++) {
        tBody.rows.elementAt(i).insertCell(j);
      }
    }

    table.setAttribute("class", "table");
    if (id != null)
      table.id = id;
    return table;
  }

  UListElement _generateList(List<String> liElemText) {
    var uList = new UListElement();
    for (int i = 0; i < liElemText.length; i++) {
      var listEntry  = new Element.li();
      listEntry.text = liElemText[i];
      uList.children.add(listEntry);
    }
    return uList;
  }
}
