import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    document.addEventListener("click", this.handleClickOutside.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside.bind(this));
  }

  handleClickOutside(event) {
    if (!this.targets.element.contains(event.target)) {
      this.close();
    }
  }

  close() {
    const popover = document.getElementById("search_popover");
    popover.innerHTML = "";
    popover.removeAttribute("src");
    popover.removeAttribute("complete");
  }
}
