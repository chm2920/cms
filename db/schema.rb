# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130514040817) do

  create_table "admins", :force => true do |t|
    t.string   "adminname"
    t.string   "password"
    t.string   "level"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ads", :force => true do |t|
    t.string   "title"
    t.string   "mark"
    t.string   "ad_type"
    t.string   "size"
    t.string   "info"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "catalogs", :force => true do |t|
    t.integer "parent_id", :default => 0
    t.integer "sortrank",  :default => 0
    t.string  "name"
    t.string  "cdir"
    t.string  "extra"
  end

  create_table "comments", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "comment_id", :default => 0
    t.string   "uname"
    t.string   "ip"
    t.text     "content"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "friendlinks", :force => true do |t|
    t.string  "title"
    t.string  "link"
    t.integer "rank",  :default => 0
  end

  create_table "guestbooks", :force => true do |t|
    t.string   "title"
    t.string   "info"
    t.string   "content"
    t.string   "reply"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "kindeditor_assets", :force => true do |t|
    t.string   "asset"
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "file_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "run_logs", :force => true do |t|
    t.string   "log_path"
    t.string   "log_method"
    t.string   "log_params"
    t.string   "log_exception"
    t.string   "log_remote_ip"
    t.datetime "created_at"
  end

  create_table "sys_settings", :force => true do |t|
    t.string "stype"
    t.text   "setting"
  end

  create_table "topic_addons", :force => true do |t|
    t.integer  "topic_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "topics", :force => true do |t|
    t.integer  "catalog_id"
    t.string   "title"
    t.string   "writer"
    t.string   "source"
    t.string   "litpic"
    t.integer  "hits",        :default => 0
    t.integer  "goodpost",    :default => 0
    t.integer  "badpost",     :default => 0
    t.integer  "notpost",     :default => 0
    t.string   "keywords"
    t.string   "description"
    t.integer  "is_trash",    :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

end
