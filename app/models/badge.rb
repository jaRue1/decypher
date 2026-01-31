# frozen_string_literal: true

class Badge < ApplicationRecord
  belongs_to :mission

  validates :name, presence: true

  # Check if badge is earned (mission completed)
  def earned?
    mission.status == "completed"
  end
end
