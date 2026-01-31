import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Fade out after 2 seconds
    setTimeout(() => {
      this.element.classList.add('opacity-0')
    }, 2000)
  }
}
