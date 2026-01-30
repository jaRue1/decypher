import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static targets = ["chart"]
  static values = {
    labels: Array,
    moodData: Array,
    motivationData: Array
  }

  connect() {
    this.renderChart()
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy()
    }
  }

  renderChart() {
    const ctx = this.chartTarget.getContext("2d")

    this.chart = new Chart(ctx, {
      type: "line",
      data: {
        labels: this.labelsValue,
        datasets: [
          {
            label: "Mood",
            data: this.moodDataValue,
            borderColor: "rgb(59, 130, 246)",
            backgroundColor: "rgba(59, 130, 246, 0.1)",
            borderWidth: 2,
            tension: 0.3,
            fill: false,
            pointBackgroundColor: "rgb(59, 130, 246)",
            pointBorderColor: "rgb(59, 130, 246)",
            pointRadius: 4,
            pointHoverRadius: 6,
            spanGaps: true
          },
          {
            label: "Motivation",
            data: this.motivationDataValue,
            borderColor: "rgb(16, 185, 129)",
            backgroundColor: "rgba(16, 185, 129, 0.1)",
            borderWidth: 2,
            tension: 0.3,
            fill: false,
            pointBackgroundColor: "rgb(16, 185, 129)",
            pointBorderColor: "rgb(16, 185, 129)",
            pointRadius: 4,
            pointHoverRadius: 6,
            spanGaps: true
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: {
          intersect: false,
          mode: "index"
        },
        plugins: {
          legend: {
            display: true,
            position: "top",
            labels: {
              color: "rgb(148, 163, 184)",
              font: {
                family: "monospace",
                size: 10
              },
              boxWidth: 12,
              padding: 8
            }
          },
          tooltip: {
            backgroundColor: "rgb(30, 41, 59)",
            titleColor: "rgb(241, 245, 249)",
            bodyColor: "rgb(148, 163, 184)",
            borderColor: "rgb(71, 85, 105)",
            borderWidth: 1,
            titleFont: {
              family: "monospace",
              size: 11
            },
            bodyFont: {
              family: "monospace",
              size: 11
            },
            padding: 8,
            callbacks: {
              label: function(context) {
                const value = context.parsed.y
                if (value === null) return `${context.dataset.label}: No data`
                return `${context.dataset.label}: ${value}/10`
              }
            }
          }
        },
        scales: {
          x: {
            grid: {
              color: "rgba(71, 85, 105, 0.3)",
              drawBorder: false
            },
            ticks: {
              color: "rgb(100, 116, 139)",
              font: {
                family: "monospace",
                size: 10
              }
            }
          },
          y: {
            min: 0,
            max: 10,
            grid: {
              color: "rgba(71, 85, 105, 0.3)",
              drawBorder: false
            },
            ticks: {
              color: "rgb(100, 116, 139)",
              font: {
                family: "monospace",
                size: 10
              },
              stepSize: 2
            }
          }
        }
      }
    })
  }
}
