import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="nav"
export default class extends Controller {
  connect() {
    document
      .getElementById("nav")
      .addEventListener("click", this.changeNavLink.bind(this));
  }

  initialize() {
    this.initialiseNavLinks();
  }

  initialiseNavLinks() {
    var buttons = this.element.querySelectorAll("button");
    var isRoot = window.location.pathname === "/";
    buttons.forEach((button) => {
      if (
        (isRoot && button.id === "leaderboard_link") ||
        button.id.split("_")[0] === window.location.pathname.replace("/", "")
      ) {
        button.classList.add("text-black");
        button.classList.remove("text-gray-500", "opacity-80");
      } else {
        button.classList.remove("text-black");
        button.classList.add("text-gray-500", "opacity-80");
      }
    });
  }

  changeNavLink(event) {
    if (event.srcElement.localName !== "button") {
      return null;
    }

    // get all buttons
    var buttons = this.element.querySelectorAll("button");

    // remove all selected text-black classes
    buttons.forEach((button) => {
      button.classList.remove("text-black");
      button.classList.add("text-gray-500", "opacity-80");
    });

    event.srcElement.classList.add("text-black");
    event.srcElement.classList.remove("text-gray-500", "opacity-80");
  }
}
