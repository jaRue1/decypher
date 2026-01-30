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

ActiveRecord::Schema[8.1].define(version: 2026_01_30_043901) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "missions", force: :cascade do |t|
    t.boolean "ai_generated"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "domain_id", null: false
    t.string "status"
    t.integer "target_level"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["domain_id"], name: "index_missions_on_domain_id"
    t.index ["user_id"], name: "index_missions_on_user_id"
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
    t.bigint "task_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["domain_id"], name: "index_skills_on_domain_id"
    t.index ["task_id"], name: "index_skills_on_task_id"
    t.index ["user_id"], name: "index_skills_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.datetime "completed_at"
    t.text "completion_proof"
    t.datetime "created_at", null: false
    t.string "description"
    t.bigint "mission_id", null: false
    t.integer "position"
    t.string "skill_name"
    t.datetime "started_at"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_tasks_on_mission_id"
  end

  create_table "user_domains", force: :cascade do |t|
    t.text "ai_assessment"
    t.datetime "created_at", null: false
    t.bigint "domain_id", null: false
    t.integer "level"
    t.jsonb "quiz_responses"
    t.boolean "setup_completed"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["domain_id"], name: "index_user_domains_on_domain_id"
    t.index ["user_id"], name: "index_user_domains_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "missions", "domains"
  add_foreign_key "missions", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "skills", "domains"
  add_foreign_key "skills", "tasks"
  add_foreign_key "skills", "users"
  add_foreign_key "tasks", "missions"
  add_foreign_key "user_domains", "domains"
  add_foreign_key "user_domains", "users"
end
