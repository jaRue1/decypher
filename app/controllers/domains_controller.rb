class DomainsController < ApplicationController
  def show
    @domain = Domain.find_by!(slug: params[:slug])
    @user_domain = Current.user.user_domains.find_by(domain: @domain)
  end
end
