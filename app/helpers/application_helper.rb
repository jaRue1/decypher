# frozen_string_literal: true

module ApplicationHelper
  LEVEL_TITLES = {
    1 => 'Beginner',
    2 => 'Beginner',
    3 => 'Novice',
    4 => 'Novice',
    5 => 'Intermediate',
    6 => 'Intermediate',
    7 => 'Advanced',
    8 => 'Advanced',
    9 => 'Expert',
    10 => 'Master'
  }.freeze

  def level_title(level)
    LEVEL_TITLES[level.to_i] || 'Unknown'
  end

  PRIORITY_LABELS = {
    1 => 'Critical',
    2 => 'High',
    3 => 'Medium',
    4 => 'Low',
    5 => 'Optional'
  }.freeze

  def priority_label(priority)
    PRIORITY_LABELS[priority.to_i] || "P#{priority}"
  end

  DIFFICULTY_LABELS = {
    1 => 'Beginner',
    2 => 'Intermediate',
    3 => 'Advanced',
    4 => 'Expert'
  }.freeze

  def difficulty_label(difficulty)
    DIFFICULTY_LABELS[difficulty.to_i] || "D#{difficulty}"
  end

  TIMEFRAME_LABELS = {
    'short_term' => 'Short-term (1-4 weeks)',
    'medium_term' => 'Medium-term (1-3 months)',
    'long_term' => 'Long-term (3+ months)'
  }.freeze

  def timeframe_label(timeframe)
    TIMEFRAME_LABELS[timeframe.to_s] || timeframe&.humanize || 'Not set'
  end

  GOAL_TYPE_LABELS = {
    'learning' => 'Learning',
    'achievement' => 'Achievement',
    'habit' => 'Habit',
    'project' => 'Project'
  }.freeze

  def goal_type_label(goal_type)
    GOAL_TYPE_LABELS[goal_type.to_s] || goal_type&.humanize || 'Goal'
  end

  GRADE_LABELS = {
    'D' => 'Foundation',
    'C' => 'Development',
    'B' => 'Proficiency',
    'A' => 'Mastery'
  }.freeze

  def grade_label(grade)
    GRADE_LABELS[grade.to_s] || grade
  end

  def priority_color(priority)
    case priority
    when 1 then 'bg-emerald-900/50 text-emerald-400'
    when 2 then 'bg-yellow-900/50 text-yellow-400'
    when 3 then 'bg-orange-900/50 text-orange-400'
    when 4 then 'bg-red-900/50 text-red-400'
    when 5 then 'bg-red-800/50 text-red-300'
    else 'bg-slate-700 text-slate-400'
    end
  end
end
