part of BattleCity;


class View {
  int delay = 25;
  Game model;
  Controller controller;
  Element htmlTable;
  ModalElement modal;
  List<Element> rows;
  List<Element> cols;
  Timer timer;
  var tutorialPart = 0;
  var tutorialSubgoals = [
    new Point(0,22), new Point(4, 22),
    new Point(18, 14), new Point(4, 11),
    new Point(22, 7), new Point(14, 7)
  ];
  var speechText = [
    "Willcomen in Battle City. In diesem Tutoriallevel lernst du die Gundlagen des Spiels."
    "Du kannst jederzeit die Steuerungs Hilfe mit der Taste (<i class=\"fa fa-gamepad\"></i>) abrufen."
    "Die Inhalte dieses Tutorials und mehr Info zum Spiel findest du unter der Taste (<i class=\"fa fa-question\"></i>).",

    "Perfekt!</br> "
    "Achtung! Du hast Stahlhindernis (<img src=\"../img/fields/bg-steel-field.png\">) vor dir!"
    " Sie ist nicht zestörbard, durchfahrbar oder kugeldurchlässig!"
    " Überhole sie und bewege dich zum nächsten Ziel!",

    "Gut gemacht!</br> "
    "Links von dir liegt ein Wasserhindernis (<img src=\"../img/fields/bg-water-field.png\">)!"
    " Sie ist nicht zestörbard oder durchfahrbar, aber kugeldurchlässig. "
    " Überhole sie und bewege dich zum nächsten Ziel!",


    "Prima!</br> "
        "Rechts von dir liegt eine Busche (<img src=\"../img/fields/bg-bush-field.png\">)!"
        " Sie ist nicht zestörbard, aber durchfahrbar und kugeldurchlässig. In der "
        "Busche sind Panzer versteckt!"
        "Fahre Sie durch bis zum nächsten Ziel!",

    "Hervorragend!</br> "
        "Links von dir liegt ein Ziegel (<img src=\"../img/fields/bg-brick-field.png\">)!"
        "Er ist zestörbard, nicht durchfahrbar oder kugeldurchlässig"
        " Zerstöre ihn und bewege dich zum nächsten Ziel!"
    ,

    "Ich sehe den Gegner auf der anderen Seite"
        " Mit einem Tap auf dem Bildschrirm kannst du schießen."
        " Zerstöre das gegnerische Fahrzeug!!!"
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
    table.id = "gamefield";
    return table;
  }



  void startLoop() {
    querySelector(".main-container").children.clear();
    _resetSpeech();
    if (model.currentLevel == 0) {
      document.getElementById("lvlTitle").text = "Tutorial";
    } else {
      document.getElementById("lvlTitle").text = "level " + model.currentLevel.toString();
    }
    querySelector(".main-container").children.add(toHTMLTable(model));
    resumeLoop();
  }


  void updateField(){
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
        buffer.write(" bg-moveable bg-");
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
    }

  void pauseLoop(){
    timer.cancel();
  }

  void resumeLoop(){
    timer = new Timer.periodic(new Duration(milliseconds: delay), (t) {
      updateField();
    });

  }


  void updateTutorialSpeech() {
    Point playerPos = model.level.player.positions[0][0];
    document.getElementById("speech").style.fontSize = "1.6vh";

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
    document.getElementById("speech").style.marginBottom = "0";
    document.getElementById("scoreStat").style.fontSize = "2vh";
    document.getElementById("scoreStat").style.marginBottom = "2vh";
    document.getElementById("scoreStat").text = "Erreichte Punkte: " + model.score.toString();
    for (int i = 0; i < model.level.player.health; i++) {
      var  health = new SpanElement();
      health.setAttribute("class", "fa fa-heart");
      health.style.paddingLeft = "1vh";
      document.getElementById("speech").children.add(health);
    }

    document.getElementById("enemiesStat").children.clear();
    document.getElementById("enemiesStat").text = "Verbliebende Gegner: ";
    document.getElementById("enemiesStat").style.fontSize = "2vh";
    document.getElementById("enemiesStat").style.marginBottom = "0";
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
    document.getElementById("speech").setAttribute("style", "");
  }

  void showCongrats() {
    var winContainer = new Element.p();
    var scoreContainer = new Element.p();

    scoreContainer.text = "Du hast " + model.score.toString() + " Punkte erreicht";
    scoreContainer.style.fontSize = "2.5vh";
    scoreContainer.setAttribute("class", "top-secret-font text-center");

    var loseImg = new ImageElement();
    loseImg.src = "../img/etc/win-banner.png";
    loseImg.style.width = "100%";
    modal.modalFooter.style.border = "0";
    winContainer.children.add(loseImg);
    modal.setModalbodyChildren(winContainer);
    modal.setModalbodyChildren(scoreContainer);
    modal.hideHeader();
    modal.showModalFooter();
    modal.backToMenuBtn.style.display = "block";
    modal.showModal();
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
    var startGame = new ImageElement();
    var qrButton = new ImageElement();

    logo.src = "../img/brand/battle-city-logo.png";
    startGame.src = "../img/etc/start-banner.png";
    qrButton.src = "../img/etc/qr-banner.png";

    logo.style.width = "100%";
    startGame.style.width = "50%";
    qrButton.style.width = "50%";



    var startMenu = new UListElement();
    startMenu.setAttribute("class", "main-menu");

    var playButton = new LIElement();
    var aboutButton = new LIElement();



    playButton.id = "play";
    qrButton.id = "menuQr";

    playButton.children.add(startGame);
    aboutButton.children.add(qrButton);


    startMenu.children.add(playButton);
    startMenu.children.add(aboutButton);

    modal.setModalbodyChildren(startMenu);

    modal.modalHeader.style.padding = "4vh";
    modal.modalHeader.style.border = "0";
    modal.modalHeader.children.add(logo);
    modal.modalBody.style.backgroundColor = "black";
    modal.modalContent.style.border = "5px dotted black";


    modal.modalWrapper.style.backgroundColor = "orange";
    modal.modalWrapper.setAttribute("class", "modal bg-img");

    modal.hideFooter();
    modal.hideCloseButton();
    modal.hideHeading();
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
    modal.modalBody.text = "Pause";
    modal.modalBody.style.fontFamily = "top-secret";
    modal.modalBody.style.fontSize = "5vh";
    modal.modalBody.style.textAlign = "center";
    document.getElementById("pause").children.first.setAttribute("class", "nav-link btn btn-primary ml-1");

    modal.hideHeader();
    modal.nextLevelBtn.style.display = "block";
    modal.showCloseButton();
    modal.showModalFooter();
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

  void showMenuQr() {
    modal.modalHeader.style.textAlign = "center";
    modal.modalHeading.text = "Teile unser Spiel!";
    modal.modalHeading.style.fontFamily = "top-secret";

    var img = new ImageElement();
    img.src = "../img/qr.svg";

    modal.modalHeader.style.padding = "4vh";
    modal.modalHeader.style.border = "0";
    modal.modalContent.style.border = "5px dotted black";


    modal.modalWrapper.style.backgroundColor = "orange";
    modal.modalWrapper.setAttribute("class", "modal bg-img");

    modal.modalBody.children.add(img);
    modal.hideCloseButton();
    modal.showModal();
    modal.showModalFooter();
    modal.backToMenuBtn.style.display = "block";
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
        break;
      case 2:
        _loadThirdHelpPart();
        tutorialPart++;
        break;
      case 3:
        _loadForthHelpPart();
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

    text.innerHtml = "Die Level stellen Schlachtfelder aus der Vogelperspektive dar und "
        "enthalten immer folgende Elemente: Das Hauptquartier, den eigenen Panzer, "
        "feindliche Panzer und Hindernisse, wie z.B. Mauern oder Wasserflächen. "
        "Das Hauptquartier, symbolisiert durch einen Wappenadler, befindet sich meist "
        "mittig am unteren Bildschirmrand und ist von einer Schutzmauer umgeben. "
        "Wird diese Mauer durch gegnerische oder eigene Schüsse zerstört und der "
        "Adler getroffen, ist das Spiel verloren. Verliert der Spieler alle Leben, "
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

    text.text = "Die Gegner erscheinen auf dem Spielfeld an fest definierten Plätzen. "
        "Mit fortschreitendem Spielverlauf kämpft der Spieler gegen schnellere und "
        "besser gepanzerte Feindpanzer (insgesamt fünf Panzertypen) und manövriert an unterschiedlichen "
        "Hindernissen wie Backstein- und Stahlmauern oder Gewässern vorbei bzw. zerschießt sie. "
        "Je nach Level variiert die Menge der jeweiligen Panzertypen. Viel Erfolg auf dem Schlachtfeld!";

    text.style.textAlign = "justify";
    text.style.fontSize = "2vh";
    modal.modalBody.children.add(text);
  }

  void _loadForthHelpPart() {
    modal.modalHeading.text = "Anleitung (4/5): Panzertypen";

    var enemiesTable = _generateTable(5, 2, "enemyTypes");
    var enemyNames = [ "easyEnemy", "medEnemy", "strongEnemy", "veryStrongEnemy", "easyEnemy"];
    var enemyProperties = [
      ["Geschwindigkeit: lansam ", "Punkte: 50 * Leben "],
      ["Geschwindigkeit: mittel",  "Punkte: 100 * Leben "],
      ["Geschwindigkeit: schnell", "Punkte: 150 * Leben"],
      ["Geschwindigkeit: sehr schnell","Punkte: 100 * Leben"],
      ["Geschwindigkeit: schnell","Punkte: 100 * Leben"]
    ];

var enemies= [
    new ImageElement(),
    new ImageElement(),
    new ImageElement(),
    new ImageElement(),
    new ImageElement()
  ];


    enemies[0].src = "../img/moveables/bg-easyEnemy-right-1.png";
    enemies[1].src = "../img/moveables/bg-medEnemy-right-1.png";
    enemies[2].src = "../img/moveables/bg-strongEnemy-right-1.png";
    enemies[3].src = "../img/moveables/bg-veryStrongEnemy-right-1.png";
    enemies[4].src = "../img/moveables/bg-easyEnemy-right-1.png";
    enemies[4].style.opacity = "0.3";

    for (int i = 0; i < enemyNames.length; i++) {
      var fieldProperties = _generateList(enemyProperties[i]);
      enemies[i].setAttribute("class", "tutorial-img-sm");
      enemiesTable.rows.elementAt(i).cells.elementAt(0).setAttribute("class", "text-center");
      enemiesTable.rows.elementAt(i).cells.elementAt(0).children.add(enemies[i]);
      enemiesTable.rows.elementAt(i).cells.elementAt(1).children.add(fieldProperties);

    }


    modal.modalBody.children.add(enemiesTable);
  }

  void _loadFifthHelpPart() {
    var text = new Element.p();

    modal.modalHeading.text = "Anleitung (5/5): Punkten und letzte Level";

    text.text = "Jeder Gegner gibt dem Spieler bei zerstörung Punkte."
      "Wenn man verliert oder das letzte Level abschließt werden einem die erreichten Punkte noch einmal angezeigt.";
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

    var loseContainer = new Element.p();
    var scoreContainer = new Element.p();

    scoreContainer.text = "Du hast " + model.score.toString() + " Punkte erreicht";
    scoreContainer.style.fontSize = "2.5vh";
    scoreContainer.setAttribute("class", "top-secret-font text-center");

    var loseImg = new ImageElement();
    loseImg.src = "../img/etc/lose-banner.png";
    loseImg.style.width = "100%";
    modal.modalFooter.style.border = "0";
    loseContainer.children.add(loseImg);
    modal.setModalbodyChildren(loseContainer);
    modal.setModalbodyChildren(scoreContainer);
    modal.hideHeader();
    modal.showModalFooter();
    modal.backToMenuBtn.style.display = "block";
    modal.showModal();
  }

  void hideLosee() {
    modal.hideModal();
  }

  void showLoading() {
    modal.backToMenuBtn.style.display = "none";
    modal.nextBtn.style.display = "none";
    modal.nextLevelBtn.style.display = "block";

    modal.modalBody.style.backgroundColor = "black";
    modal.modalContent.style.border = "5px dotted black";
    modal.modalFooter.style.background = "black";

    modal.modalHeader.style.border = "0";
    modal.modalWrapper.style.backgroundColor = "orange";
    modal.modalWrapper.setAttribute("class", "modal bg-img");

    modal.modalBody.style.color = "white";
    modal.modalBody.style.fontSize = "5vh";
    modal.modalBody.setAttribute("class", "modal-body text-center blade-runner-font");
    if (model.currentLevel == 0) {
      modal.modalBody.text = "tutorial";
    } else {
      modal.modalBody.text = "level " + model.currentLevel.toString();
    }



    modal.modalFooter.style.backgroundColor = "black";
    modal.modalFooter.style.border = "0";


    modal.hideHeader();
    modal.hideCloseButton();
    modal.showModalFooter();
    modal.showModal();
  }

  void hideLoading() {
    modal.hideFooter();
    modal.hideModal();
  }



  void updateLevelCount() {
    int levelNr = model.currentLevel;
    document.getElementById("levelNr").text = "level $levelNr";
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


  void requestFullscreen(Element element) {
    _callMethods(element, [
      'requestFullscreen',
      'webkitRequestFullscreen',
      'mozRequestFullScreen',
      'msRequestFullscreen',
      'oRequestFullscreen'
    ]);
  }

  static _callMethods(browserObject, List methods) {
    var jsElem = new JsObject.fromBrowserObject(browserObject);

    for (String methodName in methods) {
      if (jsElem.hasProperty(methodName)) {
        return jsElem.callMethod(methodName);
      }
    }
  }
}
