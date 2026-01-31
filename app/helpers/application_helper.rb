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
