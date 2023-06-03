// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["name"];
  connect() {
    console.log("Hello, Word!", this.element); // Entire div
    console.log("Hello, nameTarget!", this.nameTarget); // Entire div
  }
  greet() {
    console.log(`Hello, ${this.name}!`);
  }
  get name() {
    return this.nameTarget.value;
  }
}
