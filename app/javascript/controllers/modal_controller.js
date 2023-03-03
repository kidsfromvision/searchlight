import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["modal"];

  connect() {
    document.addEventListener("click", this.handleClickOutside.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside.bind(this));
  }

  handleClickOutside(event) {
    if (!this.modalTarget.contains(event.target)) {
      this.close();
    }
  }

  close() {
    this.modalTarget.classList.remove("active");
  }
}
