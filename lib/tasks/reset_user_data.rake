# frozen_string_literal: true

namespace :db do
  desc "Reset all user data except users and sessions (keeps domains)"
  task reset_user_data: :environment do
    puts "Resetting user data..."

    # Delete in order to respect foreign keys
    ActiveRecord::Base.transaction do
      puts "  Deleting skills..."
      Skill.delete_all

      puts "  Deleting achievements..."
      Achievement.delete_all

      puts "  Deleting badges..."
      Badge.delete_all

      puts "  Deleting objectives..."
      Objective.delete_all

      puts "  Deleting missions..."
      Mission.delete_all

      puts "  Deleting goals..."
      Goal.delete_all

      puts "  Deleting habit_logs..."
      HabitLog.delete_all

      puts "  Deleting habits..."
      Habit.delete_all

      puts "  Deleting daily_entries..."
      DailyEntry.delete_all

      puts "  Deleting domain_setups..."
      DomainSetup.delete_all

      puts "  Deleting user_domains..."
      UserDomain.delete_all

      puts "  Resetting user XP..."
      User.update_all(total_xp: 0)

      puts "Done! User data has been reset."
    end
  end
end
