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

ActiveRecord::Schema.define(version: 20170518212000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_services", force: :cascade do |t|
    t.integer "app_id"
    t.integer "service_id"
    t.index ["app_id"], name: "index_app_services_on_app_id", using: :btree
    t.index ["service_id"], name: "index_app_services_on_service_id", using: :btree
  end

  create_table "apps", force: :cascade do |t|
    t.string   "name"
    t.string   "github_auth_token"
    t.string   "github_repo"
    t.string   "github_branch"
    t.boolean  "deploying"
    t.integer  "buildpack_id"
    t.string   "hostname"
    t.string   "ssl_email"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["buildpack_id"], name: "index_apps_on_buildpack_id", using: :btree
  end

  create_table "buildpack_files", force: :cascade do |t|
    t.integer "buildpack_id"
    t.string  "source"
    t.string  "destination"
    t.boolean "env_file"
    t.string  "env_template"
    t.index ["buildpack_id"], name: "index_buildpack_files_on_buildpack_id", using: :btree
  end

  create_table "buildpacks", force: :cascade do |t|
    t.string "name"
  end

  create_table "environment_variables", force: :cascade do |t|
    t.integer "app_id"
    t.string  "name"
    t.string  "value"
    t.index ["app_id"], name: "index_environment_variables_on_app_id", using: :btree
  end

  create_table "service_variable_sources", force: :cascade do |t|
    t.integer "service_variable_id"
    t.string  "name"
    t.string  "source_model"
    t.string  "source_attribute"
    t.index ["service_variable_id"], name: "index_service_variable_sources_on_service_variable_id", using: :btree
  end

  create_table "service_variables", force: :cascade do |t|
    t.integer "service_id"
    t.string  "name"
    t.string  "build_type"
    t.string  "value"
    t.index ["service_id"], name: "index_service_variables_on_service_id", using: :btree
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
