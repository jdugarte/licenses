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

ActiveRecord::Schema.define(:version => 20121031200737) do

  create_table "applications", :force => true do |t|
    t.string   "name",                                     :default => ""
    t.string   "ProgramID",                                :default => ""
    t.decimal  "price",      :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "name",           :default => ""
    t.string   "email",          :default => ""
    t.integer  "distributor_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "clients", ["distributor_id"], :name => "index_clients_on_distributor_id"

  create_table "computers", :force => true do |t|
    t.integer  "client_id"
    t.string   "name",                           :default => ""
    t.integer  "hd_volumen_serial", :limit => 4, :default => 0
    t.integer  "motherboard_bios",  :limit => 4, :default => 0
    t.integer  "cpu",               :limit => 4, :default => 0
    t.integer  "hard_drive",        :limit => 4, :default => 0
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "computers", ["client_id"], :name => "index_computers_on_client_id"

  create_table "distributors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "main",           :default => false
    t.integer  "distributor_id"
  end

  add_index "distributors", ["distributor_id"], :name => "index_distributors_on_distributor_id"

  create_table "licenses", :force => true do |t|
    t.integer  "application_id"
    t.integer  "computer_id"
    t.string   "sitecode",          :limit => 8,  :default => ""
    t.string   "mid",               :limit => 19, :default => ""
    t.string   "activation_code",   :limit => 35, :default => ""
    t.string   "removal_code",      :limit => 8,  :default => ""
    t.integer  "hd_volumen_serial", :limit => 4,  :default => 0
    t.integer  "motherboard_bios",  :limit => 4,  :default => 0
    t.integer  "cpu",               :limit => 4,  :default => 0
    t.integer  "hard_drive",        :limit => 4,  :default => 0
    t.text     "notes"
    t.text     "removal_reason"
    t.integer  "status",            :limit => 1,  :default => 0
    t.datetime "processing_date"
    t.integer  "user_id"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "licenses", ["application_id"], :name => "index_licenses_on_application_id"
  add_index "licenses", ["computer_id"], :name => "index_licenses_on_computer_id"
  add_index "licenses", ["user_id"], :name => "index_licenses_on_user_id"

  create_table "movements", :force => true do |t|
    t.integer  "license_id"
    t.integer  "application_id"
    t.integer  "computer_id"
    t.string   "sitecode",          :limit => 8,  :default => ""
    t.string   "mid",               :limit => 19, :default => ""
    t.string   "activation_code",   :limit => 35, :default => ""
    t.string   "removal_code",      :limit => 8,  :default => ""
    t.integer  "hd_volumen_serial", :limit => 4,  :default => 0
    t.integer  "motherboard_bios",  :limit => 4,  :default => 0
    t.integer  "cpu",               :limit => 4,  :default => 0
    t.integer  "hard_drive",        :limit => 4,  :default => 0
    t.text     "notes"
    t.text     "removal_reason"
    t.integer  "status",            :limit => 1,  :default => 0
    t.datetime "processing_date"
    t.integer  "user_id"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "movements", ["application_id"], :name => "index_movements_on_application_id"
  add_index "movements", ["computer_id"], :name => "index_movements_on_computer_id"
  add_index "movements", ["license_id"], :name => "index_movements_on_license_id"
  add_index "movements", ["user_id"], :name => "index_movements_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "name"
    t.boolean  "admin",                  :default => false
    t.integer  "distributor_id"
  end

  add_index "users", ["distributor_id"], :name => "index_users_on_distributor_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
