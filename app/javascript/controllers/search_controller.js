import { Controller } from "@hotwired/stimulus";
import debounce from "debounce";

export default class extends Controller {
  initialize() {
    this.submit = debounce(this.submit.bind(this), 300);
  }

  submit() {
    this.element.requestSubmit();
    this.element.close();
  }

  close(e) {
    e.preventDefault();
    this.element.parentElement.removeAttribute("src")
    this.element.remove()
  }

}
