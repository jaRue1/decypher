import { Controller } from "@hotwired/stimulus"

  export default class extends Controller {
    static targets = ["modal"]
    static values = {
      title: { type: String, default: "Confirm Delete" },
      message: { type: String, default: "Are you sure? This cannot be undone." }
    }

    open(event) {
      event.preventDefault()
      this.formToSubmit = event.target.closest("form") || event.target
      this.modalTarget.classList.remove("hidden")
    }

    close() {
      this.modalTarget.classList.add("hidden")
    }

    confirm() {
      if (this.formToSubmit.requestSubmit) {
        this.formToSubmit.requestSubmit()
      } else {
        this.formToSubmit.submit()
      }
      this.close()
    }

    // Close on escape key
    closeOnEscape(event) {
      if (event.key === "Escape") {
        this.close()
      }
    }

    // Close when clicking backdrop
    closeOnBackdrop(event) {
      if (event.target === this.modalTarget) {
        this.close()
      }
    }
  }