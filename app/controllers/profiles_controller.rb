# frozen_string_literal: true

class ProfilesController < ApplicationController
  def show
    load_profile_data
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:username)
  end

  def load_profile_data
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

    # Habits data
    @habits = @user.habits.active.ordered
    @habits_stats = @user.monthly_habit_stats(Date.current)
    @top_streaks = @habits.sort_by { |h| -h.current_streak }.first(5)

    # Journal data (last 7 days)
    @recent_entries = @user.daily_entries.where(date: 7.days.ago..Date.current).order(date: :desc)
    @avg_mood = @recent_entries.where.not(mood_score: nil).average(:mood_score)&.round(1)
    @avg_motivation = @recent_entries.where.not(motivation_score: nil).average(:motivation_score)&.round(1)
  end
end
