# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_02_16_023859) do

  create_table "insights", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "life_aspect", default: "", null: false
    t.string "impact", default: "", null: false
    t.string "insight_text", default: "", null: false
    t.datetime "expiry_time"
    t.boolean "viewed", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "physician_users", force: :cascade do |t|
    t.string "user_user_id"
    t.string "physician_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "questions", default: {}
  end

  create_table "physicians", force: :cascade do |t|
    t.string "user_id"
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "questions", default: {}
  end

  create_table "read_user_analysis_results", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "correlation_result", null: false
    t.string "unique_analysis_id", null: false
    t.datetime "timestamp_added", null: false
    t.boolean "viewed", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "user_analysis_results", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "correlation_result", null: false
    t.string "unique_analysis_id", null: false
    t.datetime "timestamp_added", null: false
    t.boolean "viewed", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_created_analyses", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "unique_analysis_id"
    t.string "anchor", null: false
    t.string "antecedent_name", null: false
    t.string "antecedent_table", null: false
    t.string "antecedent_parameter"
    t.string "consequent_name", null: false
    t.string "consequent_table", null: false
    t.string "consequent_parameter"
    t.string "aggregate_function", null: false
    t.string "antecedent_type", null: false
    t.string "consequent_type", null: false
    t.string "consequent_interval"
    t.string "antecedent_interval"
    t.string "query_interval"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "name"
    t.string "user_id", null: false
    t.boolean "is_physician", default: false, null: false
    t.json "info", default: {}
    t.json "questions", default: {}
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_id"], name: "index_users_on_user_id"
  end

end
