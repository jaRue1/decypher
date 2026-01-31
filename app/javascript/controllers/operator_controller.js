import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "loading"]

  connect() {
    // Listen for turbo form submission
    this.element.addEventListener("turbo:submit-start", this.showLoading.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-start", this.showLoading.bind(this))
  }

  showLoading() {
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = true
      this.buttonTarget.textContent = "Generating..."
      this.buttonTarget.classList.add("opacity-50", "cursor-wait")
    }

    if (this.hasLoadingTarget) {
      this.loadingTarget.classList.remove("hidden")
    }
  }
}
