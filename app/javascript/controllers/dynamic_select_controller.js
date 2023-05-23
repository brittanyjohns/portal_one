import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["doc", "chat"];

  connect() {
    this.selected();
  }

  selected() {
    this.hideFields();
    switch (this.selectTarget.value) {
      case "doc":
        this.docTarget.classList.remove("hidden");
        break;
      case "chat":
        this.chatTarget.classList.remove("hidden");
        break;
    }
  }

  hideFields() {
    this.docTarget.classList.add("hidden");
    this.chatTarget.classList.add("hidden");
  }
}
