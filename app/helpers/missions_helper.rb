module MissionsHelper
  def status_color(status)
    case status
    when "standby"
      "bg-slate-700 text-slate-300"
    when "active"
      "bg-blue-400/10 text-blue-400"
    when "completed"
      "bg-emerald-400/10 text-emerald-400"
    when "aborted"
      "bg-amber-400/10 text-amber-400"
    else
      "bg-slate-700 text-slate-400"
    end
  end

  def grade_color(grade)
    case grade
    when "A"
      "bg-emerald-400/10 text-emerald-400 border border-emerald-500/30"
    when "B"
      "bg-blue-400/10 text-blue-400 border border-blue-500/30"
    when "C"
      "bg-amber-400/10 text-amber-400 border border-amber-500/30"
    when "D"
      "bg-slate-400/10 text-slate-400 border border-slate-500/30"
    else
      "bg-slate-700 text-slate-400"
    end
  end

  def grade_label(grade)
    case grade
    when "A" then "Level Up"
    when "B" then "Advanced"
    when "C" then "Intermediate"
    when "D" then "Beginner"
    else "Ungraded"
    end
  end

  def objective_status_color(status)
    case status
    when "pending", nil
      "bg-slate-700 text-slate-400"
    when "active"
      "bg-blue-400/10 text-blue-400"
    when "completed"
      "bg-emerald-400/10 text-emerald-400"
    else
      "bg-slate-700 text-slate-400"
    end
  end
end
