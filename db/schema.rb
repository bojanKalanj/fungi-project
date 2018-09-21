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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180921110731) do

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id",    limit: 4
    t.string   "auditable_type",  limit: 255
    t.integer  "associated_id",   limit: 4
    t.string   "associated_type", limit: 255
    t.integer  "user_id",         limit: 4
    t.string   "user_type",       limit: 255
    t.string   "username",        limit: 255
    t.string   "action",          limit: 255
    t.text     "audited_changes", limit: 65535
    t.integer  "version",         limit: 4,     default: 0
    t.string   "comment",         limit: 255
    t.string   "remote_address",  limit: 255
    t.string   "request_uuid",    limit: 255
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "characteristics", force: :cascade do |t|
    t.integer  "reference_id",  limit: 4,     null: false
    t.integer  "species_id",    limit: 4,     null: false
    t.boolean  "edible"
    t.boolean  "cultivated"
    t.boolean  "poisonous"
    t.boolean  "medicinal"
    t.text     "fruiting_body", limit: 65535
    t.text     "microscopy",    limit: 65535
    t.text     "flesh",         limit: 65535
    t.text     "chemistry",     limit: 65535
    t.text     "note",          limit: 65535
    t.text     "habitats",      limit: 65535
    t.text     "substrates",    limit: 65535
    t.string   "slug",          limit: 255,   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "characteristics", ["reference_id"], name: "index_characteristics_on_reference_id", using: :btree
  add_index "characteristics", ["slug"], name: "index_characteristics_on_slug", using: :btree
  add_index "characteristics", ["species_id"], name: "index_characteristics_on_species_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "commentable_type", limit: 255
    t.integer  "commentable_id",   limit: 4
    t.integer  "user_id",          limit: 4
    t.text     "body",             limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "languages", force: :cascade do |t|
    t.integer  "parent_id",  limit: 4
    t.string   "name",       limit: 255, null: false
    t.string   "title",      limit: 255, null: false
    t.string   "locale",     limit: 255, null: false
    t.string   "flag",       limit: 255, null: false
    t.boolean  "default"
    t.string   "slug",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "languages", ["slug"], name: "index_languages_on_slug", unique: true, using: :btree

  create_table "localized_pages", force: :cascade do |t|
    t.integer  "language_id", limit: 4
    t.integer  "page_id",     limit: 4
    t.string   "title",       limit: 255,                  null: false
    t.text     "content",     limit: 65535
    t.string   "slug",        limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "locale",      limit: 255,   default: "sr"
  end

  add_index "localized_pages", ["language_id"], name: "index_localized_pages_on_language_id", using: :btree
  add_index "localized_pages", ["page_id"], name: "index_localized_pages_on_page_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "utm",        limit: 255, null: false
    t.string   "slug",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "locations", ["name"], name: "index_locations_on_name", using: :btree
  add_index "locations", ["slug"], name: "index_locations_on_slug", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.string   "slug",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.integer "reference_id", limit: 4
    t.integer "user_id",      limit: 4
    t.integer "species_id",   limit: 4
    t.integer "specimen_id",  limit: 4
    t.string  "image",        limit: 255,                 null: false
    t.string  "type",         limit: 255,                 null: false
    t.boolean "approved",                 default: false
    t.string  "source_url",   limit: 255
    t.string  "source_title", limit: 255
  end

  add_index "pictures", ["reference_id"], name: "fk_rails_89135305c9", using: :btree
  add_index "pictures", ["species_id"], name: "fk_rails_6feec66a2f", using: :btree
  add_index "pictures", ["user_id"], name: "fk_rails_3268570edc", using: :btree

  create_table "references", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.string   "authors",    limit: 255
    t.string   "isbn",       limit: 255
    t.string   "url",        limit: 255
    t.string   "slug",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "references", ["slug"], name: "index_references_on_slug", using: :btree

  create_table "species", force: :cascade do |t|
    t.string   "name",                 limit: 255,   null: false
    t.string   "genus",                limit: 255,   null: false
    t.string   "familia",              limit: 255,   null: false
    t.string   "ordo",                 limit: 255,   null: false
    t.string   "subclassis",           limit: 255,   null: false
    t.string   "classis",              limit: 255,   null: false
    t.string   "subphylum",            limit: 255,   null: false
    t.string   "phylum",               limit: 255,   null: false
    t.text     "synonyms",             limit: 65535
    t.string   "growth_type",          limit: 255
    t.string   "nutritive_group",      limit: 255
    t.string   "url",                  limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "square_pic",           limit: 255
    t.string   "square_pic_reference", limit: 255
  end

  add_index "species", ["url"], name: "index_species_on_url", using: :btree

  create_table "specimen", force: :cascade do |t|
    t.integer  "species_id",           limit: 4,     null: false
    t.integer  "location_id",          limit: 4,     null: false
    t.integer  "legator_id",           limit: 4,     null: false
    t.string   "legator_text",         limit: 255
    t.integer  "determinator_id",      limit: 4
    t.string   "determinator_text",    limit: 255
    t.text     "habitat",              limit: 65535
    t.text     "substrate",            limit: 65535
    t.date     "date",                               null: false
    t.text     "quantity",             limit: 65535
    t.text     "note",                 limit: 65535
    t.boolean  "approved"
    t.string   "slug",                 limit: 255,   null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "square_pic",           limit: 255
    t.string   "square_pic_reference", limit: 255
    t.string   "number",               limit: 255
  end

  add_index "specimen", ["determinator_id"], name: "index_specimen_on_determinator_id", using: :btree
  add_index "specimen", ["legator_id"], name: "index_specimen_on_legator_id", using: :btree
  add_index "specimen", ["location_id"], name: "index_specimen_on_location_id", using: :btree
  add_index "specimen", ["slug"], name: "index_specimen_on_slug", using: :btree
  add_index "specimen", ["species_id"], name: "index_specimen_on_species_id", using: :btree

  create_table "stats", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "data",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,                    null: false
    t.string   "encrypted_password",     limit: 255
    t.string   "first_name",             limit: 255,                    null: false
    t.string   "last_name",              limit: 255,                    null: false
    t.string   "title",                  limit: 255
    t.string   "role",                   limit: 255,   default: "user", null: false
    t.string   "institution",            limit: 255
    t.string   "phone",                  limit: 255
    t.string   "slug",                   limit: 255,                    null: false
    t.string   "authentication_token",   limit: 255
    t.datetime "deactivated_at"
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.text     "about",                  limit: 65535
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "localized_pages", "languages"
  add_foreign_key "localized_pages", "pages"
  add_foreign_key "pictures", "references"
  add_foreign_key "pictures", "species"
  add_foreign_key "pictures", "users"
  add_foreign_key "specimen", "locations"
  add_foreign_key "specimen", "species"
end
