import { Controller } from "@hotwired/stimulus";
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["statusSelect"];

  connect() {
    this.statusSelectTarget.addEventListener("change", () => this.submitForm());
  }

  submitForm() {
    Rails.ajax({
      type: "patch",
      url: this.element.action,
      data: new FormData(this.element),
    });
  }
}
