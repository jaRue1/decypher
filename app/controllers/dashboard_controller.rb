# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @domains = Domain.ordered
    @user_domains = Current.user.user_domains.where(setup_completed: true).index_by(&:domain_id)
    @power_level = calculate_power_level
  end

  private

  def calculate_power_level
    completed = Current.user.user_domains.where(setup_completed: true)
    return 0 if completed.empty?

    (completed.average(:level).to_f / 6 * 100).round
  end
end
