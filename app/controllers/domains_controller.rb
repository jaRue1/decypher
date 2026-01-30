class DomainsController < ApplicationController
  def show
    @domain = Domain.find_by!(slug: params[:slug])
    @user_domain = Current.user.user_domains.find_by(domain: @domain)
  end

  def setup
      @domain = Domain.find_by!(slug: params[:slug])
  end

  def complete_setup
      @domain = Domain.find_by!(slug: params[:slug])
      user_domain = Current.user.user_domains.find_or_initialize_by(domain: @domain)
      user_domain.update!(
        level: params[:level].to_i,
        setup_completed: true,
        quiz_responses: params[:responses].to_json
      )
      redirect_to domain_path(@domain.slug), notice: "#{@domain.name} setup complete!"
  end


end
