part of BattleCity;

/**
 *
 */
class View {


  /**
   *  Die Verzögerung für den Update-Timer.
   */
  int delay = 25;

  /**
   * Timer, um den Spielfeld zu updaten.
   */
  Timer gameFieldUpdateTimer;

  /**
   * Model des Spieles laut MVC-Pattern.
   */
  Game model;

  /**
   * Kontroller des Spieles laut MVC-Pattern.
   */
  Controller controller;

  /**
   * Spielfeld als HTML-Tabelle.
   */
  Element htmlGamefield;

  /**
   * Die Zeilen des Spielfelds.
   */
  List<Element> rows;

  /**
   * Die Spalten des Spielfelds.
   */
  List<Element> cols;

  /**
   * Das Modale Fenster fuer verschiedene Inhalte.
   */
  ModalElement modal;

  /**
   * Zaeler fuer den naechsten Teil des Anleitung.
   */
  var tutorialPart = 0;

  /**
   * Punkte, die im Tutorial lvl mit Animation markiert werden sollen.
   */
  var tutorialSubgoals = [
    new Point(0,22), new Point(4, 22),
    new Point(18, 14), new Point(4, 11),
    new Point(22, 7), new Point(14, 7)
  ];

  /**
   * Die Texte, die in der Sprechblase angezeigt werden sollen,
   * wenn der Spieler den Markierten Punkt erreicht.
   */
  var speechText = [
    "Willkommen in Battle City. In diesem Tutoriallevel lernst du die Grundlagen des Spieles."
    "Du kannst jederzeit die Steuerungshilfe mit der Taste (<i class=\"fa fa-gamepad\"></i>) aufrufen."
    "Die Inhalte dieses Tutorials und mehr Info zum Spiel findest du unter der Taste (<i class=\"fa fa-question\"></i>).",

    "Perfekt!</br> "
    "Achtung! Du hast ein Stahlhindernis (<img src=\"../img/fields/bg-steel-field.png\">) vor dir!"
    " Es ist nicht zestörbar, durchfahrbar oder kugeldurchlässig!"
    " Fahr vorbei und bewege dich zum nächsten Ziel!",

    "Gut gemacht!</br> "
    "Links von dir ist Wasser (<img src=\"../img/fields/bg-water-field.png\">)!"
    " Es ist nicht zestörbar oder durchfahrbar, aber kugeldurchlässig. "
    " Fahr vorbei und bewege dich zum nächsten Ziel!",


    "Prima!</br> "
        "Rechts von dir ist ein Busch (<img src=\"../img/fields/bg-bush-field.png\">)!"
        " Er ist nicht zestörbar, aber durchfahrbar und kugeldurchlässig. In "
        "Büschen sind manchmal Panzer versteckt!"
        "Fahre durch bis zum nächsten Ziel!",

    "Hervorragend!</br> "
        "Links von dir ist ein Ziegel (<img src=\"../img/fields/bg-brick-field.png\">)!"
        "Er ist zestörbar, aber nicht durchfahrbar oder kugeldurchlässig"
        " Zerstöre ihn und bewege dich zum nächsten Ziel!"
    ,

    "Ich sehe den Gegner auf der anderen Seite"
        " Mit einem Tap auf dem Bildschrirm kannst du schießen."
        " Zerstöre das gegnerische Fahrzeug!!!"
  ];


  /**
   * @param Game das Model des Spiels.
   * @param Controller die Steuerung des Spiels.
   */
  View(Game this.model, Controller this.controller) {
    modal = new ModalElement.created();
  }


  /**
   * Bildet Spielfed in Dart nach HTML-Tabelle ab.
   * @param Game das Model des Spields.
   * @returen TableElement - Spielfeld als HTML-Tabelle
   */
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

////////////////////////////////////////////////////
// Steuerung fuer das Update des Spielfelds in View
///////////////////////////////////////////////////

  /**
   * Startet Update des Spielfelds.
   */
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

  /**
   * Pausiert Update des Spielfelds.
   */
  void pauseLoop(){
    gameFieldUpdateTimer.cancel();
  }

  /**
   * Setzt Update des Spielfelds fort, falls das Update frueher pausiert wurde.
   */
  void resumeLoop(){
    gameFieldUpdateTimer = new Timer.periodic(new Duration(milliseconds: delay), (t) {
      updateField();
    });

  }

////////////////////////////////////////////////////
// Update des Spielfelds und der Sprechblase
///////////////////////////////////////////////////

  /**
   * Updated die HTML-Tabelle und Sprechblase fuer alle Aenderungen auf
   * dem Spielfeld im Model.
   */
  void updateField(){
      htmlGamefield = querySelector(".main-container").children.first.children.first;
      rows = htmlGamefield.children;
      for (int i = 0; i < rows.length; i++) {
        cols = rows[i].children;
        for (int j = 0; j < cols.length; j++) {
          cols[j].setAttribute("class", "bg-" +
              model.level.gamefield.gameField[i + 1][j + 1].ground.type);
        }
      }

      if (model.currentLevel == 0 && tutorialSubgoals.length != 0) {
        _updateTutorialSpeech();
      } else {
        _updateLevelStatSpeech();
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

  /**
   * Aendert die Sprechblase im Tutorial-Level abhaengig von der Position des
   * Panzers auf dem Spielfeld.
   */
  void _updateTutorialSpeech() {
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

    _higlightTutorialSubgoal(tutorialSubgoals[0]);
  }


  /**
   * Markiert den Quadrat rund um der gegebenen Position mit einer CSS-Animation.
   * @param Point die linke obere Position des Quadrats.
   */
  void _higlightTutorialSubgoal(Point position) {
    rows[position.y].children.elementAt(position.x).setAttribute("class", "bg-road invalid");
    rows[position.y].children.elementAt(position.x + 1).setAttribute("class", "bg-road invalid");
    rows[position.y + 1].children.elementAt(position.x).setAttribute("class", "bg-road invalid");
    rows[position.y + 1].children.elementAt(position.x + 1).setAttribute("class", "bg-road invalid");

  }

  /**
   * Aktualisiert die Statistik (Lebenspunkte, Gegneranzahl, Gewinnpunkten).
   */
  void _updateLevelStatSpeech() {

    document.getElementById("speech").children.clear();
    document.getElementById("speech").text = "Lebenspunkte:";
    document.getElementById("speech").style.fontSize = "2vh";
    document.getElementById("speech").style.marginBottom = "0";

    document.getElementById("scoreStat").style.fontSize = "2vh";
    document.getElementById("scoreStat").style.marginBottom = "2vh";
    document.getElementById("scoreStat").text = "Erreichte Punkte: " + model.score.toString();

    document.getElementById("enemiesStat").children.clear();
    document.getElementById("enemiesStat").text = "Verbliebende Gegner: ";
    document.getElementById("enemiesStat").style.fontSize = "2vh";
    document.getElementById("enemiesStat").style.marginBottom = "0";


    for (int i = 0; i < model.level.player.health; i++) {
      var  healthIcon = new SpanElement();
      healthIcon.setAttribute("class", "fa fa-heart");
      healthIcon.style.paddingLeft = "1vh";
      document.getElementById("speech").children.add(healthIcon);
    }

    for (int i = 0; i < model.level.gamefield.enemyCount; i++) {
      var  enemyIcon = new ImageElement();
      enemyIcon.src = "../img/etc/enemy-stat.png";
      enemyIcon.style.paddingLeft = "1vh";
      enemyIcon.style.width = "4vh";
      document.getElementById("enemiesStat").children.add(enemyIcon);
    }
  }

  /**
   * Setzt die Kinderelemente der Sprechblase zurueck.
   */
  void _resetSpeech() {
    document.getElementById("speech").children.clear();
    document.getElementById("enemiesStat").children.clear();
    document.getElementById("speech").setAttribute("style", "");
  }

////////////////////////////////////////////////////
// Modal fuer Gewinnen/Verlieren/naechter Level
///////////////////////////////////////////////////

  /**
   * Laedt die Information ueber Sieg in das Modallfenster.
   * Die fuer dieses Modalfenster unnoetigen Elemente werden versteckt.
   */
  void showWin() {
    var winContainer = new Element.p();
    var scoreContainer = new Element.p();
    var winImg = new ImageElement();


    scoreContainer.text = "Du hast " + model.score.toString() + " Punkte erreicht";
    scoreContainer.style.fontSize = "2.5vh";
    scoreContainer.setAttribute("class", "top-secret-font text-center");


    winImg.src = "../img/etc/win-banner.png";
    winImg.style.width = "100%";

    winContainer.children.add(winImg);

    modal.modalFooter.style.border = "0";

    modal.setModalbodyChildren(winContainer);
    modal.setModalbodyChildren(scoreContainer);

    modal.hideHeader();
    modal.showModalFooter();
    modal.backToMenuBtn.style.display = "block";
    modal.showModal();
  }

  /**
   * Laedt die Information ueber Niederlage in das Modallfenster.
   * Die fuer dieses Modalfenster unnoetigen Elemente werden versteckt.
   */
  void showLose() {
    var loseContainer = new Element.p();
    var scoreContainer = new Element.p();
    var loseImg = new ImageElement();

    scoreContainer.text = "Du hast " + model.score.toString() + " Punkte erreicht";
    scoreContainer.style.fontSize = "2.5vh";
    scoreContainer.setAttribute("class", "top-secret-font text-center");

    loseImg.src = "../img/etc/lose-banner.png";
    loseImg.style.width = "100%";

    loseContainer.children.add(loseImg);

    modal.modalFooter.style.border = "0";

    modal.setModalbodyChildren(loseContainer);
    modal.setModalbodyChildren(scoreContainer);

    modal.hideHeader();
    modal.showModalFooter();
    modal.backToMenuBtn.style.display = "block";
    modal.showModal();
  }

  /**
   * Laedt die Levelnummer in das Modallefenster.
   * Die fuer dieses Modalfenster unnoetigen Elemente werden versteckt.
   */
  void showLoading() {
    modal.modalWrapper.style.backgroundColor = "orange";
    modal.modalWrapper.setAttribute("class", "modal bg-img");

    modal.modalHeader.style.border = "0";

    modal.modalBody.style.backgroundColor = "black";
    modal.modalBody.style.color = "white";
    modal.modalBody.style.fontSize = "5vh";
    modal.modalBody.setAttribute("class", "modal-body text-center blade-runner-font");

    modal.modalContent.style.border = "5px dotted black";

    modal.modalFooter.style.backgroundColor = "black";
    modal.modalFooter.style.border = "0";
    modal.modalFooter.style.background = "black";

    if (model.currentLevel == 0) {
      modal.modalBody.text = "tutorial";
    } else {
      modal.modalBody.text = "level " + model.currentLevel.toString();
    }


    modal.backToMenuBtn.style.display = "none";
    modal.nextBtn.style.display = "none";
    modal.nextLevelBtn.style.display = "block";

    modal.hideHeader();
    modal.hideCloseButton();
    modal.showModalFooter();
    modal.showModal();
  }


  void hideLosee() {
    modal.hideModal();
  }

  void hideLoading() {
    modal.hideFooter();
    modal.hideModal();
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
