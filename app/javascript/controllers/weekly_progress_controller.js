import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static targets = ["barChart", "donutChart"]
  static values = {
    labels: Array,
    data: Array,
    percentage: Number,
    completed: Number,
    total: Number
  }

  connect() {
    this.renderBarChart()
    this.renderDonutChart()

    // Watch for container resize (e.g., sidebar toggle)
    this.resizeObserver = new ResizeObserver(() => {
      if (this.barChartInstance) this.barChartInstance.resize()
      if (this.donutChartInstance) this.donutChartInstance.resize()
    })
    this.resizeObserver.observe(this.element)
  }

  disconnect() {
    if (this.resizeObserver) this.resizeObserver.disconnect()
    if (this.barChartInstance) this.barChartInstance.destroy()
    if (this.donutChartInstance) this.donutChartInstance.destroy()
  }

  renderBarChart() {
    if (!this.hasBarChartTarget) return

    const ctx = this.barChartTarget.getContext('2d')
    const maxValue = Math.max(...this.dataValue, 1)

    this.barChartInstance = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: this.labelsValue,
        datasets: [{
          data: this.dataValue,
          backgroundColor: this.dataValue.map((val, i) => {
            // Highlight today
            const today = new Date().getDay()
            return i === today ? '#10b981' : '#3b82f6'
          }),
          borderRadius: 4,
          borderSkipped: false
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            backgroundColor: '#1e293b',
            titleColor: '#94a3b8',
            bodyColor: '#f1f5f9',
            borderColor: '#334155',
            borderWidth: 1,
            displayColors: false,
            callbacks: {
              label: (ctx) => `${ctx.parsed.y} habits completed`
            }
          }
        },
        scales: {
          x: {
            grid: { display: false },
            ticks: {
              color: '#64748b',
              font: { family: 'monospace', size: 10 }
            }
          },
          y: {
            beginAtZero: true,
            max: maxValue + 1,
            grid: { color: '#1e293b' },
            ticks: {
              color: '#64748b',
              font: { family: 'monospace', size: 10 },
              stepSize: 1
            }
          }
        }
      }
    })
  }

  renderDonutChart() {
    if (!this.hasDonutChartTarget) return

    const ctx = this.donutChartTarget.getContext('2d')
    const completed = this.completedValue
    const remaining = this.totalValue - completed

    this.donutChartInstance = new Chart(ctx, {
      type: 'doughnut',
      data: {
        datasets: [{
          data: [completed, remaining],
          backgroundColor: ['#10b981', '#1e293b'],
          borderWidth: 0,
          cutout: '75%'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: { enabled: false }
        }
      }
    })
  }
}
