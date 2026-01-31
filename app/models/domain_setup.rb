# frozen_string_literal: true

class DomainSetup < ApplicationRecord
  belongs_to :user
  belongs_to :domain

  STEPS = %w[goals background preview completed].freeze

  validates :step, inclusion: { in: STEPS }

  def goals_step?
    step == "goals"
  end

  def background_step?
    step == "background"
  end

  def preview_step?
    step == "preview"
  end

  def completed?
    step == "completed"
  end

  def advance_to!(next_step)
    update!(step: next_step)
  end

  def plan_generated?
    generated_plan.present? && generated_plan["goals"].present?
  end
end
