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

ActiveRecord::Schema.define(version: 2020_05_04_150925) do

  create_table "badges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", limit: 255, null: false
    t.string "icon", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_badges_on_name", unique: true
  end

  create_table "badges_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "badge_id"
    t.bigint "user_id"
    t.index ["badge_id"], name: "index_badges_users_on_badge_id"
    t.index ["user_id"], name: "index_badges_users_on_user_id"
  end

  create_table "likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "nweet_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nweet_id"], name: "index_likes_on_nweet_id"
    t.index ["user_id", "nweet_id"], name: "index_likes_on_user_id_and_nweet_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "link_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "link_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id", "tag_id"], name: "index_link_tags_on_link_id_and_tag_id", unique: true
    t.index ["link_id"], name: "index_link_tags_on_link_id"
    t.index ["tag_id"], name: "index_link_tags_on_tag_id"
  end

  create_table "links", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.text "title"
    t.text "description", limit: 16777215
    t.string "image"
    t.string "card"
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "image_width"
    t.integer "image_height"
    t.index ["url"], name: "index_links_on_url", unique: true
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "origin_id"
    t.integer "destination_id"
    t.integer "action", null: false
    t.integer "like_id"
    t.integer "relationship_id"
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "statement"
    t.index ["destination_id"], name: "index_notifications_on_destination_id"
  end

  create_table "nweet_links", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "nweet_id"
    t.bigint "link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id"], name: "index_nweet_links_on_link_id"
    t.index ["nweet_id"], name: "index_nweet_links_on_nweet_id"
  end

  create_table "nweets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.datetime "did_at"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "statement"
    t.string "url_digest"
    t.datetime "latest_liked_time"
    t.index ["url_digest"], name: "index_nweets_on_url_digest", unique: true
    t.index ["user_id", "did_at"], name: "index_nweets_on_user_id_and_did_at"
    t.index ["user_id"], name: "index_nweets_on_user_id"
  end

  create_table "preferences", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_preferences_on_tag_id"
    t.index ["user_id"], name: "index_preferences_on_user_id"
  end

  create_table "relationships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followee_id"], name: "index_relationships_on_followee_id"
    t.index ["follower_id", "followee_id"], name: "index_relationships_on_follower_id_and_followee_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 30, null: false
    t.boolean "censored_by_default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", limit: 200
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "handle_name", limit: 30
    t.string "screen_name", limit: 20
    t.string "icon"
    t.string "url_digest"
    t.string "twitter_uid"
    t.string "twitter_screen_name"
    t.string "twitter_url"
    t.string "twitter_access_secret"
    t.string "twitter_access_token"
    t.boolean "autotweet_enabled", default: false
    t.string "autotweet_content", limit: 40, default: "射精しました！ #nuita [LINK]"
    t.string "biography", limit: 140
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["screen_name"], name: "index_users_on_screen_name", unique: true
    t.index ["url_digest"], name: "index_users_on_url_digest", unique: true
  end

  add_foreign_key "likes", "nweets"
  add_foreign_key "likes", "users"
  add_foreign_key "link_tags", "links"
  add_foreign_key "link_tags", "tags"
  add_foreign_key "nweet_links", "links"
  add_foreign_key "nweet_links", "nweets"
  add_foreign_key "nweets", "users"
  add_foreign_key "preferences", "tags"
  add_foreign_key "preferences", "users"
end
