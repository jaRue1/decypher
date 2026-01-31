# frozen_string_literal: true

module DailyEntriesHelper
  def mood_emoji(score)
    case score
    when 1..2 then "😔"
    when 3..4 then "😕"
    when 5..6 then "😐"
    when 7..8 then "🙂"
    when 9..10 then "😊"
    else ""
    end
  end

  def mood_color(score)
    case score
    when 1..3 then "text-red-400"
    when 4..5 then "text-amber-400"
    when 6..7 then "text-yellow-400"
    when 8..9 then "text-emerald-400"
    when 10 then "text-green-400"
    else "text-slate-500"
    end
  end

  def motivation_color(score)
    case score
    when 1..3 then "text-red-400"
    when 4..5 then "text-amber-400"
    when 6..7 then "text-yellow-400"
    when 8..9 then "text-emerald-400"
    when 10 then "text-green-400"
    else "text-slate-500"
    end
  end
end
