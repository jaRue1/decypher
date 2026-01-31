# frozen_string_literal: true

class DailyEntry < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :user_id, uniqueness: { scope: :date }
  validates :mood_score, inclusion: { in: 1..10 }, allow_nil: true
  validates :motivation_score, inclusion: { in: 1..10 }, allow_nil: true

  scope :for_date, ->(date) { where(date: date) }
  scope :for_month, ->(date) { where(date: date.all_month) }
  scope :recent, -> { order(date: :desc) }

  def mood_label
    case mood_score
    when 1..3 then "Low"
    when 4..6 then "Moderate"
    when 7..8 then "Good"
    when 9..10 then "Excellent"
    end
  end

  def motivation_label
    case motivation_score
    when 1..3 then "Low"
    when 4..6 then "Moderate"
    when 7..8 then "High"
    when 9..10 then "Peak"
    end
  end
end
