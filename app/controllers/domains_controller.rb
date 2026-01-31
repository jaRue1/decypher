# frozen_string_literal: true

class DomainsController < ApplicationController
  before_action :set_domain, only: %i[show setup complete_setup reset setup_wizard save_step generate_plan preview_plan
                                      confirm_plan reset_setup]

  def show
    @user_domain = Current.user.user_domains.find_by(domain: @domain)
  end

  def setup; end

  def complete_setup
    user_domain = Current.user.user_domains.find_or_initialize_by(domain: @domain)
    user_domain.update!(
      level: params[:level].to_i,
      setup_completed: true,
      quiz_responses: params[:responses].to_json
    )
    redirect_to domain_path(@domain.slug), notice: "#{@domain.name} setup complete!"
  end

  def reset
    user_domain = Current.user.user_domains.find_by(domain: @domain)

    if user_domain
      user_domain.destroy
      redirect_to domain_path(@domain.slug), notice: "#{@domain.name} has been reset."
    else
      redirect_to domain_path(@domain.slug), alert: "Nothing to reset."
    end
  end

  # Operator Wizard Actions

  def setup_wizard
    @domain_setup = Current.user.domain_setups.find_or_create_by!(domain: @domain)
  end

  def save_step
    @domain_setup = Current.user.domain_setups.find_by!(domain: @domain)

    case @domain_setup.step
    when "goals"
      @domain_setup.update!(
        goals_input: params[:goals_input],
        blockers_input: params[:blockers_input],
        success_input: params[:success_input]
      )
      @domain_setup.advance_to!("background")
    when "background"
      @domain_setup.update!(background_input: params[:background_input])
      @domain_setup.advance_to!("preview")
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to setup_wizard_domain_path(@domain.slug) }
    end
  end

  def generate_plan
    @domain_setup = Current.user.domain_setups.find_by!(domain: @domain)

    begin
      operator = Operator::DomainSetup.new(@domain_setup)
      operator.generate_plan

      redirect_to preview_plan_domain_path(@domain.slug)
    rescue Operator::Base::ApiError, Operator::Base::InvalidResponseError, Operator::DomainSetup::PlanValidationError => e
      redirect_to setup_wizard_domain_path(@domain.slug), alert: "Plan generation failed: #{e.message}"
    end
  end

  def preview_plan
    @domain_setup = Current.user.domain_setups.find_by!(domain: @domain)

    unless @domain_setup.plan_generated?
      redirect_to setup_wizard_domain_path(@domain.slug), alert: "No plan generated yet."
      return
    end

    @plan = @domain_setup.generated_plan
  end

  def confirm_plan
    @domain_setup = Current.user.domain_setups.find_by!(domain: @domain)

    begin
      operator = Operator::DomainSetup.new(@domain_setup)
      operator.apply_plan!

      redirect_to domain_path(@domain.slug), notice: "#{@domain.name} has been set up by The Operator!"
    rescue StandardError => e
      Rails.logger.error("Operator confirm_plan failed: #{e.class} - #{e.message}")
      Rails.logger.error(e.backtrace.first(10).join("\n"))
      redirect_to preview_plan_domain_path(@domain.slug), alert: "Failed to apply plan: #{e.message}"
    end
  end

  def reset_setup
    domain_setup = Current.user.domain_setups.find_by(domain: @domain)
    domain_setup&.destroy

    redirect_to setup_wizard_domain_path(@domain.slug), notice: "Setup has been reset."
  end

  private

  def set_domain
    @domain = Domain.find_by!(slug: params[:slug])
  end
end
