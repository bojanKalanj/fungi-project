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

ActiveRecord::Schema.define(version: 20150409183256) do

  create_table "characteristics", force: :cascade do |t|
    t.integer  "reference_id",  limit: 4,     null: false
    t.integer  "species_id",    limit: 4,     null: false
    t.boolean  "edible",        limit: 1
    t.boolean  "cultivated",    limit: 1
    t.boolean  "poisonous",     limit: 1
    t.boolean  "medicinal",     limit: 1
    t.text     "fruiting_body", limit: 65535
    t.text     "microscopy",    limit: 65535
    t.text     "flesh",         limit: 65535
    t.text     "chemistry",     limit: 65535
    t.text     "note",          limit: 65535
    t.text     "habitats",      limit: 65535
    t.text     "substrates",    limit: 65535
    t.string   "uuid",          limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "characteristics", ["reference_id"], name: "index_characteristics_on_reference_id", using: :btree
  add_index "characteristics", ["species_id"], name: "index_characteristics_on_species_id", using: :btree
  add_index "characteristics", ["uuid"], name: "index_characteristics_on_uuid", using: :btree

  create_table "languages", force: :cascade do |t|
    t.integer  "parent_id",  limit: 4
    t.string   "name",       limit: 255, null: false
    t.string   "title",      limit: 255, null: false
    t.string   "locale",     limit: 255, null: false
    t.string   "flag",       limit: 255, null: false
    t.boolean  "default",    limit: 1
    t.string   "slug",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "languages", ["slug"], name: "index_languages_on_slug", unique: true, using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "utm",        limit: 255, null: false
    t.string   "uuid",       limit: 255
    t.string   "slug",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "locations", ["name"], name: "index_locations_on_name", using: :btree
  add_index "locations", ["slug"], name: "index_locations_on_slug", using: :btree

  create_table "references", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.string   "authors",    limit: 255
    t.string   "isbn",       limit: 255
    t.string   "url",        limit: 255
    t.string   "uuid",       limit: 255
    t.string   "slug",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "references", ["slug"], name: "index_references_on_slug", using: :btree
  add_index "references", ["uuid"], name: "index_references_on_uuid", using: :btree

  create_table "species", force: :cascade do |t|
    t.string   "name",            limit: 255,   null: false
    t.string   "genus",           limit: 255,   null: false
    t.string   "familia",         limit: 255,   null: false
    t.string   "ordo",            limit: 255,   null: false
    t.string   "subclassis",      limit: 255,   null: false
    t.string   "classis",         limit: 255,   null: false
    t.string   "subphylum",       limit: 255,   null: false
    t.string   "phylum",          limit: 255,   null: false
    t.text     "synonyms",        limit: 65535
    t.string   "growth_type",     limit: 255
    t.string   "nutritive_group", limit: 255
    t.string   "url",             limit: 255
    t.string   "uuid",            limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "species", ["url"], name: "index_species_on_url", using: :btree
  add_index "species", ["uuid"], name: "index_species_on_uuid", using: :btree

  create_table "specimen", force: :cascade do |t|
    t.integer  "species_id",        limit: 4,     null: false
    t.integer  "location_id",       limit: 4,     null: false
    t.integer  "legator_id",        limit: 4,     null: false
    t.string   "legator_text",      limit: 255
    t.integer  "determinator_id",   limit: 4
    t.string   "determinator_text", limit: 255
    t.text     "habitats",          limit: 65535
    t.text     "substrates",        limit: 65535
    t.date     "date",                            null: false
    t.text     "quantity",          limit: 65535
    t.text     "note",              limit: 65535
    t.boolean  "approved",          limit: 1
    t.string   "uuid",              limit: 255
    t.string   "slug",              limit: 255,   null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "specimen", ["determinator_id"], name: "index_specimen_on_determinator_id", using: :btree
  add_index "specimen", ["legator_id"], name: "index_specimen_on_legator_id", using: :btree
  add_index "specimen", ["location_id"], name: "index_specimen_on_location_id", using: :btree
  add_index "specimen", ["slug"], name: "index_specimen_on_slug", using: :btree
  add_index "specimen", ["species_id"], name: "index_specimen_on_species_id", using: :btree
  add_index "specimen", ["uuid"], name: "index_specimen_on_uuid", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,                  null: false
    t.string   "encrypted_password",     limit: 255
    t.string   "first_name",             limit: 255,                  null: false
    t.string   "last_name",              limit: 255,                  null: false
    t.string   "title",                  limit: 255
    t.string   "role",                   limit: 255, default: "user", null: false
    t.string   "institution",            limit: 255
    t.string   "phone",                  limit: 255
    t.string   "uuid",                   limit: 255
    t.string   "slug",                   limit: 255,                  null: false
    t.string   "authentication_token",   limit: 255
    t.datetime "deactivated_at"
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", using: :btree

end
