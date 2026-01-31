import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "loading", "form"]

  connect() {
    // Listen for turbo form submission on the element or any forms within
    this.element.addEventListener("turbo:submit-start", this.showLoading.bind(this))
    this.element.addEventListener("turbo:submit-end", this.hideLoading.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-start", this.showLoading.bind(this))
    this.element.removeEventListener("turbo:submit-end", this.hideLoading.bind(this))
  }

  showLoading(event) {
    // Find the submit button that was clicked
    const form = event.target
    const button = form.querySelector('input[type="submit"], button[type="submit"]')

    if (button) {
      button.disabled = true
      button.dataset.originalText = button.value || button.textContent
      if (button.tagName === 'INPUT') {
        button.value = "Generating..."
      } else {
        button.textContent = "Generating..."
      }
      button.classList.add("opacity-50", "cursor-wait")
    }

    if (this.hasLoadingTarget) {
      this.loadingTarget.classList.remove("hidden")
    }
  }

  hideLoading(event) {
    const form = event.target
    const button = form.querySelector('input[type="submit"], button[type="submit"]')

    if (button && button.dataset.originalText) {
      button.disabled = false
      if (button.tagName === 'INPUT') {
        button.value = button.dataset.originalText
      } else {
        button.textContent = button.dataset.originalText
      }
      button.classList.remove("opacity-50", "cursor-wait")
    }

    if (this.hasLoadingTarget) {
      this.loadingTarget.classList.add("hidden")
    }
  }
}
