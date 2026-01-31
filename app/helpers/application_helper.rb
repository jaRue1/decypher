# frozen_string_literal: true

module ApplicationHelper
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
