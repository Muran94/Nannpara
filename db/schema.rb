# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180411120044) do

  create_table "activities", force: :cascade do |t|
    t.integer "activity_type_id"
    t.integer "obtained_experience_point", default: 0
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_type_id"], name: "index_activities_on_activity_type_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "activity_types", force: :cascade do |t|
    t.string "name_ja"
    t.string "name_en"
    t.integer "experience_point", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_en"], name: "index_activity_types_on_name_en"
    t.index ["name_ja"], name: "index_activity_types_on_name_ja"
  end

  create_table "blog_articles", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_blog_articles_on_user_id"
  end

  create_table "blog_comments", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.integer "blog_article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_article_id"], name: "index_blog_comments_on_blog_article_id"
    t.index ["user_id"], name: "index_blog_comments_on_user_id"
  end

  create_table "levels", force: :cascade do |t|
    t.integer "required_experience_point"
    t.string "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["required_experience_point"], name: "index_levels_on_required_experience_point"
  end

  create_table "messages", force: :cascade do |t|
    t.text "message"
    t.integer "user_id"
    t.integer "recruitment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recruitment_id"], name: "index_messages_on_recruitment_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "ranking_entries", force: :cascade do |t|
    t.integer "user_id"
    t.integer "ranking_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ranking_id"], name: "index_ranking_entries_on_ranking_id"
    t.index ["user_id"], name: "index_ranking_entries_on_user_id"
  end

  create_table "ranking_types", force: :cascade do |t|
    t.string "name_en"
    t.string "name_ja"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rankings", force: :cascade do |t|
    t.integer "ranking_type_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["closed_at"], name: "index_rankings_on_closed_at"
    t.index ["end_at"], name: "index_rankings_on_end_at"
    t.index ["ranking_type_id"], name: "index_rankings_on_ranking_type_id"
    t.index ["start_at"], name: "index_rankings_on_start_at"
  end

  create_table "recruitments", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "event_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "prefecture_code"
    t.boolean "linked_with_kanto_nanpa_messageboard"
    t.string "kanto_nanpa_messageboard_delete_key"
    t.datetime "closed_at"
    t.integer "messages_count", default: 0, null: false
    t.index ["closed_at"], name: "index_recruitments_on_closed_at"
    t.index ["event_date"], name: "index_recruitments_on_event_date"
    t.index ["prefecture_code"], name: "index_recruitments_on_prefecture_code"
    t.index ["user_id"], name: "index_recruitments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "introduction"
    t.string "experience"
    t.integer "age"
    t.integer "prefecture_code"
    t.string "image"
    t.boolean "direct_mail"
    t.integer "experience_point", default: 0
    t.integer "level_id", default: 1
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
