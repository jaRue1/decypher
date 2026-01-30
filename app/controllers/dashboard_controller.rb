class DashboardController < ApplicationController
  def index
    @domains = Domain.all
  end
end
