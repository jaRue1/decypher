# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_30_223057) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.bigint "achievable_id"
    t.string "achievable_type"
    t.datetime "achieved_at"
    t.string "achievement_type", null: false
    t.datetime "created_at", null: false
    t.jsonb "metadata", default: {}
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["achievable_type", "achievable_id"], name: "index_achievements_on_achievable"
    t.index ["user_id", "achievement_type", "achievable_type", "achievable_id"], name: "index_achievements_uniqueness", unique: true
    t.index ["user_id"], name: "index_achievements_on_user_id"
  end

  create_table "badges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.bigint "mission_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_badges_on_mission_id"
  end

  create_table "domains", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.jsonb "level_titles"
    t.string "name"
    t.integer "position", default: 0, null: false
    t.json "quiz_questions"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_domains_on_position"
    t.index ["slug"], name: "index_domains_on_slug", unique: true
  end

  create_table "goals", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "domain_id"
    t.string "goal_type"
    t.string "status"
    t.string "timeframe"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["domain_id"], name: "index_goals_on_domain_id"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "habit_logs", force: :cascade do |t|
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.bigint "habit_id", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_habit_logs_on_date"
    t.index ["habit_id", "date"], name: "index_habit_logs_on_habit_id_and_date", unique: true
    t.index ["habit_id"], name: "index_habit_logs_on_habit_id"
  end

  create_table "habits", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "color"
    t.datetime "created_at", null: false
    t.bigint "domain_id"
    t.string "icon"
    t.string "name", null: false
    t.integer "position"
    t.integer "target_days_per_month", default: 30
    t.integer "target_days_per_week", default: 7
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["domain_id"], name: "index_habits_on_domain_id"
    t.index ["user_id", "active"], name: "index_habits_on_user_id_and_active"
    t.index ["user_id", "position"], name: "index_habits_on_user_id_and_position"
    t.index ["user_id"], name: "index_habits_on_user_id"
  end

  create_table "missions", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "domain_id", null: false
    t.string "grade"
    t.boolean "operator_generated"
    t.datetime "started_at"
    t.string "status"
    t.integer "target_level"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["domain_id"], name: "index_missions_on_domain_id"
    t.index ["user_id"], name: "index_missions_on_user_id"
  end

  create_table "objectives", force: :cascade do |t|
    t.datetime "completed_at"
    t.text "completion_proof"
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "difficulty", default: 1
    t.bigint "mission_id", null: false
    t.integer "position"
    t.string "skill_name"
    t.datetime "started_at"
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "xp_reward", default: 25
    t.index ["mission_id"], name: "index_objectives_on_mission_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.datetime "acquired_at"
    t.datetime "created_at", null: false
    t.bigint "domain_id", null: false
    t.string "name"
    t.bigint "objective_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "xp_value", default: 25
    t.index ["domain_id"], name: "index_skills_on_domain_id"
    t.index ["objective_id"], name: "index_skills_on_objective_id"
    t.index ["user_id"], name: "index_skills_on_user_id"
  end

  create_table "user_domains", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "current_grade", default: "D"
    t.bigint "domain_id", null: false
    t.integer "level"
    t.datetime "level_started_at"
    t.text "operator_assessment"
    t.jsonb "quiz_responses"
    t.boolean "setup_completed"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "xp", default: 0, null: false
    t.index ["domain_id"], name: "index_user_domains_on_domain_id"
    t.index ["user_id"], name: "index_user_domains_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.integer "total_xp", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "achievements", "users"
  add_foreign_key "badges", "missions"
  add_foreign_key "goals", "domains"
  add_foreign_key "goals", "users"
  add_foreign_key "habit_logs", "habits"
  add_foreign_key "habits", "domains"
  add_foreign_key "habits", "users"
  add_foreign_key "missions", "domains"
  add_foreign_key "missions", "users"
  add_foreign_key "objectives", "missions"
  add_foreign_key "sessions", "users"
  add_foreign_key "skills", "domains"
  add_foreign_key "skills", "objectives"
  add_foreign_key "skills", "users"
  add_foreign_key "user_domains", "domains"
  add_foreign_key "user_domains", "users"
end
