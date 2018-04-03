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

ActiveRecord::Schema.define(version: 20_180_402_151_552) do
  create_table 'counters', force: :cascade do |t|
    t.string 'counter_type'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_counters_on_user_id'
  end

  create_table 'messages', force: :cascade do |t|
    t.text 'message'
    t.integer 'user_id'
    t.integer 'recruitment_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['recruitment_id'], name: 'index_messages_on_recruitment_id'
    t.index ['user_id'], name: 'index_messages_on_user_id'
  end

  create_table 'recruitments', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.datetime 'event_date'
    t.string 'venue'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'prefecture_code'
    t.boolean 'closed', default: false
    t.boolean 'linked_with_kanto_nanpa_messageboard'
    t.string 'kanto_nanpa_messageboard_delete_key'
    t.index ['user_id'], name: 'index_recruitments_on_user_id'
  end

  create_table 'tweets', force: :cascade do |t|
    t.text 'content'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_tweets_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.integer 'failed_attempts', default: 0, null: false
    t.datetime 'locked_at'
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.text 'introduction'
    t.string 'experience'
    t.integer 'age'
    t.integer 'prefecture_code'
    t.string 'image'
    t.boolean 'direct_mail'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end
end
