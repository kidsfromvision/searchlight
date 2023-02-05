import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["statusSelect"];

  connect() {
    this.statusSelectTarget.addEventListener("change", () => this.submitForm());
  }

  submitForm() {
    this.element.submit();
  }
}
