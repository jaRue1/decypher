import { Controller } from "@hotwired/stimulus"
import { Chart } from "chart.js/auto"

export default class extends Controller {
  static values = {
    labels: Array,
    data: Array
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
    const ctx = this.element.getContext('2d')

    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: this.labelsValue,
        datasets: [{
          label: 'Completion Rate',
          data: this.dataValue,
          fill: true,
          borderColor: '#3b82f6',
          backgroundColor: 'rgba(59, 130, 246, 0.1)',
          borderWidth: 2,
          tension: 0.3,
          pointRadius: 0,
          pointHoverRadius: 4,
          pointHoverBackgroundColor: '#3b82f6',
          pointHoverBorderColor: '#fff',
          pointHoverBorderWidth: 2
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: {
          intersect: false,
          mode: 'index'
        },
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            backgroundColor: '#1e293b',
            titleColor: '#94a3b8',
            bodyColor: '#f1f5f9',
            borderColor: '#334155',
            borderWidth: 1,
            padding: 12,
            displayColors: false,
            titleFont: {
              family: 'monospace',
              size: 11
            },
            bodyFont: {
              family: 'monospace',
              size: 13
            },
            callbacks: {
              label: function(context) {
                return context.parsed.y + '% completed'
              }
            }
          }
        },
        scales: {
          x: {
            grid: {
              color: '#1e293b',
              drawBorder: false
            },
            ticks: {
              color: '#64748b',
              font: {
                family: 'monospace',
                size: 10
              },
              maxRotation: 0
            }
          },
          y: {
            beginAtZero: true,
            max: 100,
            grid: {
              color: '#1e293b',
              drawBorder: false
            },
            ticks: {
              color: '#64748b',
              font: {
                family: 'monospace',
                size: 10
              },
              callback: function(value) {
                return value + '%'
              },
              stepSize: 25
            }
          }
        }
      }
    })
  }
}
