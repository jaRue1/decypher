class ProfilesController < ApplicationController
  def show
    @user = Current.user
    @power_level = @user.power_level
    @total_xp = @user.total_xp || 0

    # Domain stats
    @domains = Domain.ordered
    @user_domains = @user.user_domains.includes(:domain).index_by(&:domain_id)

    # Mission stats
    @missions_completed = @user.missions.completed.count
    @active_missions = @user.missions.active.includes(:domain, :objectives)

    # Recent achievements (last 10)
    @recent_achievements = @user.achievements.recent.limit(10)

    # Skills grouped by domain
    @skills_by_domain = @user.skills.includes(:domain).group_by(&:domain)
    @total_skills = @user.skills.count
  end
end
