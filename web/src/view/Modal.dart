import 'dart:html';

class Modal {
  var modalWindow = document.getElementById('showModal');
  var span = querySelector(".close");
  var header = querySelector(".modal-header h6");
      
  void displayModal(String name) {
    _clearOnLoad();
    switch (name) {
      case "qr":
        _loadQrInModal();
        break;
      case "help":
        _loadHelpInModal();
        break;
      case "controlls":
        _loadControllsInModal();
        break;
    }
    document.getElementById(name).children.first.setAttribute("class", "nav-link btn btn-primary ml-1");
    modalWindow.style.display = "block";
  }

  void hideModal(String name) {
    modalWindow.style.display = "none";
    document.getElementById(name).children.first.setAttribute("class", "nav-link btn btn-secondary ml-1");
  }

  void _loadQrInModal() {
    querySelector(".modal-header h6").text= "Zeige unser Spiel deinen Freunden!";
    //modalHeadingWrapper.children.add(h);

    var img = new ImageElement();
    img.src = "../img/qr.svg";

    //modalWindow.querySelector(".modal-header").children.add(h);
    modalWindow.querySelector(".modal-body").children.add(img);
  }

  void _clearOnLoad() {
    modalWindow.querySelector(".modal-body").children.clear();
    document.getElementById("modalContent").setAttribute("style", ""); // remove size attributes
  }

  void _loadHelpInModal() {
    header.text = "Anleitung (2/3): Feldertypen";

    var fieldsTable = _generateTable(6, 2);
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
      var properties = _generateFieldTypeList(groundProperties[i]);

      bgFieldImg.src = "../img/fields/bg-" + imgNames[i] +"-field.png";
      bgFieldImg.setAttribute("class", "tutorial-img-sm");


      fieldsTable.rows.elementAt(i).cells.elementAt(0).setAttribute("class", "text-center");

      fieldsTable.rows.elementAt(i).cells.elementAt(0).children.add(bgFieldImg);
      fieldsTable.rows.elementAt(i).cells.elementAt(1).children.add(properties);
    }


    document.getElementById("modalBody").children.add(fieldsTable);
  }

  void _loadControllsInModal() {
    header.text = "Hilfe: Steuerung";

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

    document.getElementById("modalBody").children.add(swipesTable);
  }

///////////////////////////////////
//  Helping methods
///////////////////////////////////

  TableElement _generateTable(int row, int col) {
    var table = new TableElement();
    var tBody = table.createTBody();

    for (int i = 0; i < row; i++) {
      tBody.insertRow(i);
      for (int j = 0; j < col; j++) {
        tBody.rows.elementAt(i).insertCell(j);
      }
    }

    table.setAttribute("class", "table");
    return table;
  }

  UListElement _generateFieldTypeList(List<String> groundTypes) {
    var uList = new UListElement();
    for (int i = 0; i < 3; i++) {
      var listEntry  = new Element.li();
      listEntry.text = groundTypes[i];
      uList.children.add(listEntry);
    }
    return uList;
  }
}