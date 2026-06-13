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

ActiveRecord::Schema[8.1].define(version: 2026_06_13_000002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "blueprints", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.boolean "public", default: true, null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.text "yaml_content", null: false
    t.index ["public"], name: "index_blueprints_on_public"
    t.index ["slug"], name: "index_blueprints_on_slug"
    t.index ["user_id", "slug"], name: "index_blueprints_on_user_id_and_slug", unique: true
    t.index ["user_id"], name: "index_blueprints_on_user_id"
  end

  create_table "dotfiles", force: :cascade do |t|
    t.bigint "blueprint_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "target_path", null: false
    t.datetime "updated_at", null: false
    t.index ["blueprint_id", "target_path"], name: "index_dotfiles_on_blueprint_id_and_target_path", unique: true
    t.index ["blueprint_id"], name: "index_dotfiles_on_blueprint_id"
  end

  create_table "environment_variables", force: :cascade do |t|
    t.bigint "blueprint_id", null: false
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.string "value", null: false
    t.index ["blueprint_id", "key"], name: "index_environment_variables_on_blueprint_id_and_key", unique: true
    t.index ["blueprint_id"], name: "index_environment_variables_on_blueprint_id"
  end

  create_table "packages", force: :cascade do |t|
    t.bigint "blueprint_id", null: false
    t.string "category", default: "pacman", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "version"
    t.index ["blueprint_id", "name", "category"], name: "index_packages_on_blueprint_name_category"
    t.index ["blueprint_id"], name: "index_packages_on_blueprint_id"
    t.index ["category"], name: "index_packages_on_category"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "blueprint_id", null: false
    t.datetime "created_at", null: false
    t.boolean "enabled", default: true, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["blueprint_id", "name"], name: "index_services_on_blueprint_id_and_name", unique: true
    t.index ["blueprint_id"], name: "index_services_on_blueprint_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "authentication_token"
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "locked_at"
    t.string "name", default: "", null: false
    t.string "remember_token"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "blueprints", "users"
  add_foreign_key "dotfiles", "blueprints"
  add_foreign_key "environment_variables", "blueprints"
  add_foreign_key "packages", "blueprints"
  add_foreign_key "services", "blueprints"
end
