import 'dart:html';

class ModalElement {

  DivElement modalWrapper;
  DivElement modalContent;
  DivElement modalHeader;
  HeadingElement modalHeading;
  SpanElement closeButton;
  DivElement modalBody;
  DivElement modalFooter;
  ButtonElement nextBtn;



  ModalElement.created()  {
    modalWrapper = new DivElement();
    modalContent = new DivElement();
    modalHeader = new DivElement();
    modalHeading = new HeadingElement.h6();
    closeButton = new SpanElement();
    modalBody = new DivElement();
    modalFooter = new DivElement();
    nextBtn = new ButtonElement();

    modalWrapper.id = "showModal";
    modalWrapper.setAttribute("class", "modal");

    modalContent.id = "modalContent";
    modalContent.setAttribute("class", "modal-content");

    modalHeader.setAttribute("class", "modal-header");

    closeButton.id = "closeBtn";
    closeButton.setAttribute("class", "close fa fa-times");

    modalBody.id = "modalBody";
    modalBody.setAttribute("class", "modal-body");

    nextBtn.id = "next";
    nextBtn.setAttribute("class", "btn btn-primary btn-block");
    nextBtn.text= "weiter";

    modalFooter.setAttribute("class", "modal-footer");
    modalFooter.style.display = "none";

    modalHeader.children.add(modalHeading);
    modalHeader.children.add(closeButton);

    modalContent.children.add(modalHeader);
    modalContent.children.add(modalBody);
    modalContent.children.add(modalFooter);

    modalFooter.children.add(nextBtn);

    modalWrapper.children.add(modalContent);

    document.getElementById("modalWrapper").children.add(modalWrapper);
  }

  void showCloseButton() {
    closeButton.style.display = "block";
  }

  void showHeading() {
    modalHeading.style.display = "block";
  }

  void showModal() {
    modalWrapper.style.display = "block";
  }

  void showModalFooter() {
    modalFooter.style.display = "block";
  }

  void hideHeading() {
    modalHeading.style.display = "none";
  }

  void hideCloseButton() {
    closeButton.style.display = "none";
  }

  void hideModal() {
    resetModal();
    modalWrapper.style.display = "none";
  }

  void hideFooter() {
    modalFooter.style.display = "none";
  }

  void setModalbodyChildren(Element child) {
    modalBody.children.add(child);
  }

  void resetModal() {
    modalWrapper.id = "showModal";
    modalWrapper.setAttribute("class", "modal");
    modalWrapper.setAttribute("style", "");

    modalContent.id = "modalContent";
    modalContent.setAttribute("class", "modal-content");
    modalContent.setAttribute("style", "");

    modalHeader.setAttribute("class", "modal-header");
    modalHeader.setAttribute("style", "");
    closeButton.setAttribute("class", "close fa fa-times");

    modalBody.id = "modalBody";
    modalBody.setAttribute("class", "modal-body");
    modalBody.setAttribute("style", "");
    modalBody.children.clear();
  }
}