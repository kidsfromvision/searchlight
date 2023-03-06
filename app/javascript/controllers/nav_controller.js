import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="nav"
export default class extends Controller {
  connect() {
    document
      .getElementById("nav")
      .addEventListener("click", this.changeNavLink.bind(this));
  }

  changeNavLink(event) {
    if (event.srcElement.localName !== "button") {
      return null;
    }

    // get all buttons
    var buttons = this.element.querySelectorAll("button");

    // remove all selected text-black classes
    buttons.forEach((button) => {
      console.log(button);
      button.classList.remove("text-black");
      button.classList.add("text-gray-400");
    });

    event.srcElement.classList.add("text-black");
    event.srcElement.classList.remove("text-gray-400");
  }
}
