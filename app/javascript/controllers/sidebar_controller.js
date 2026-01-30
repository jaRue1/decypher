import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "main", "logo", "logoText", "navText", "userInfo", "toggleIcon", "navItem", "header", "logoContainer", "toggleButton"]

  connect() {
    // Restore state from localStorage
    const collapsed = localStorage.getItem("sidebar-collapsed") === "true"
    if (collapsed) {
      this.collapse(false)
    }
  }

  toggle() {
    const isCollapsed = this.sidebarTarget.classList.contains("w-16")
    if (isCollapsed) {
      this.expand()
    } else {
      this.collapse(true)
    }
  }

  collapse(save = true) {
    // Sidebar width
    this.sidebarTarget.classList.remove("w-64")
    this.sidebarTarget.classList.add("w-16")

    // Main content margin
    this.mainTarget.classList.remove("ml-64")
    this.mainTarget.classList.add("ml-16")

    // Hide text elements
    this.logoTextTargets.forEach(el => el.classList.add("hidden"))
    this.navTextTargets.forEach(el => el.classList.add("hidden"))
    this.userInfoTargets.forEach(el => el.classList.add("hidden"))

    // Rotate toggle icon to point right (expand direction)
    this.toggleIconTarget.classList.add("rotate-180")

    // Center items when collapsed
    this.sidebarTarget.querySelectorAll("nav a").forEach(link => {
      link.classList.add("justify-center")
      link.classList.remove("gap-3")
    })

    // Center user section
    if (this.hasNavItemTarget) {
      this.navItemTarget.classList.add("justify-center")
      this.navItemTarget.classList.remove("gap-3")
    }

    // Center logo container
    if (this.hasLogoContainerTarget) {
      this.logoContainerTarget.classList.add("justify-center")
      this.logoContainerTarget.classList.remove("gap-3")
    }

    // Center toggle button
    if (this.hasToggleButtonTarget) {
      this.toggleButtonTarget.classList.add("justify-center")
      this.toggleButtonTarget.classList.remove("gap-3")
    }

    if (save) {
      localStorage.setItem("sidebar-collapsed", "true")
    }
  }

  expand() {
    // Sidebar width
    this.sidebarTarget.classList.remove("w-16")
    this.sidebarTarget.classList.add("w-64")

    // Main content margin
    this.mainTarget.classList.remove("ml-16")
    this.mainTarget.classList.add("ml-64")

    // Show text elements
    this.logoTextTargets.forEach(el => el.classList.remove("hidden"))
    this.navTextTargets.forEach(el => el.classList.remove("hidden"))
    this.userInfoTargets.forEach(el => el.classList.remove("hidden"))

    // Rotate toggle icon to point left (collapse direction)
    this.toggleIconTarget.classList.remove("rotate-180")

    // Restore nav item alignment
    this.sidebarTarget.querySelectorAll("nav a").forEach(link => {
      link.classList.remove("justify-center")
      link.classList.add("gap-3")
    })

    // Restore user section alignment
    if (this.hasNavItemTarget) {
      this.navItemTarget.classList.remove("justify-center")
      this.navItemTarget.classList.add("gap-3")
    }

    // Restore logo container alignment
    if (this.hasLogoContainerTarget) {
      this.logoContainerTarget.classList.remove("justify-center")
      this.logoContainerTarget.classList.add("gap-3")
    }

    // Restore toggle button alignment
    if (this.hasToggleButtonTarget) {
      this.toggleButtonTarget.classList.remove("justify-center")
      this.toggleButtonTarget.classList.add("gap-3")
    }

    localStorage.setItem("sidebar-collapsed", "false")
  }
}
