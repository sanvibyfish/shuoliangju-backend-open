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

ActiveRecord::Schema.define(version: 2020_08_05_054859) do

  create_table "accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["confirmation_token"], name: "index_accounts_on_confirmation_token", unique: true
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["invitation_token"], name: "index_accounts_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_accounts_on_invitations_count"
    t.index ["invited_by_id"], name: "index_accounts_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_accounts_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_accounts_on_unlock_token", unique: true
  end

  create_table "action_text_rich_texts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "actions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "action_type", null: false
    t.string "action_option"
    t.string "target_type"
    t.integer "target_id"
    t.string "user_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_type", "target_type", "target_id", "user_id", "user_type"], name: "idx_at_tt_ti_ui_ut"
    t.index ["action_type", "target_type", "target_id", "user_type", "user_id"], name: "uk_action_target_user", unique: true
    t.index ["target_type", "target_id", "action_type"], name: "index_actions_on_target_type_and_target_id_and_action_type"
    t.index ["user_type", "user_id", "action_type"], name: "index_actions_on_user_type_and_user_id_and_action_type"
  end

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "apps", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "app_key"
    t.integer "status"
    t.integer "auto_updated"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "logo_url"
    t.string "summary"
    t.string "wechat_app_id", comment: "微信app_id"
    t.string "wechat_app_secret", comment: "微信app_secret"
    t.integer "own_id", comment: "创建用户"
    t.string "qrcode_url"
    t.index ["own_id"], name: "index_apps_on_own_id"
  end

  create_table "articles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.integer "likes_count", default: 0
    t.string "image_url"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "app_id"
    t.string "summary", comment: "摘要"
    t.string "author", comment: "作者"
    t.integer "state", default: 0, comment: "0:草稿，1:发布"
    t.bigint "account_id"
    t.datetime "deleted_at"
    t.index ["account_id"], name: "index_articles_on_account_id"
    t.index ["app_id"], name: "index_articles_on_app_id"
    t.index ["deleted_at"], name: "index_articles_on_deleted_at"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "boards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "app_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["app_id"], name: "index_boards_on_app_id"
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "body"
    t.string "image_url"
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.datetime "deleted_at"
    t.bigint "user_id", null: false
    t.bigint "app_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "reply_to_id"
    t.bigint "parent_id"
    t.integer "likes_count", default: 0
    t.index ["app_id"], name: "index_comments_on_app_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["reply_to_id"], name: "index_comments_on_reply_to_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "exception_tracks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "body", size: :medium
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "summary"
    t.string "logo_url"
    t.string "qrcode_url"
    t.string "group_own_wechat"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "actor_id", null: false
    t.bigint "user_id"
    t.string "notify_type", null: false
    t.string "target_type"
    t.bigint "target_id"
    t.string "second_target_type"
    t.bigint "second_target_id"
    t.string "third_target_type"
    t.bigint "third_target_id"
    t.datetime "read_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["second_target_type", "second_target_id"], name: "index_notifications_on_second_target_type_and_second_target_id"
    t.index ["target_type", "target_id"], name: "index_notifications_on_target_type_and_target_id"
    t.index ["third_target_type", "third_target_id"], name: "index_notifications_on_third_target_type_and_third_target_id"
    t.index ["user_id", "notify_type"], name: "index_notifications_on_user_id_and_notify_type"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "posts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "app_id", null: false
    t.bigint "user_id", null: false
    t.text "body"
    t.string "video"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "images_url"
    t.bigint "section_id"
    t.datetime "deleted_at"
    t.string "who_deleted"
    t.integer "grade", default: 0
    t.integer "likes_count", default: 0
    t.integer "stars_count", default: 0
    t.boolean "top", default: false, comment: "是否置顶"
    t.integer "state", default: 0, comment: "0:正常, -1:隐藏"
    t.string "qrcode_url"
    t.index ["app_id"], name: "index_posts_on_app_id"
    t.index ["deleted_at"], name: "index_posts_on_deleted_at"
    t.index ["section_id"], name: "index_posts_on_section_id"
    t.index ["user_id", "app_id"], name: "index_posts_on_user_id_and_app_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "body"
    t.bigint "price"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "images_url"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "reports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "reportable_type", null: false
    t.bigint "reportable_id", null: false
    t.bigint "app_id", null: false
    t.integer "state", default: 0, comment: "0:未处理, 1:已处理"
    t.integer "action", default: 0, comment: "0:未操作, 1:忽略, 2:删除, 3:隐藏"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["app_id"], name: "index_reports_on_app_id"
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable_type_and_reportable_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "sections", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "icon_url"
    t.integer "sort", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "app_id"
    t.string "summary"
    t.integer "role", default: 0, comment: "0:正常, 1:管理员"
    t.index ["app_id"], name: "index_sections_on_app_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.string "cellphone"
    t.string "avatar_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country_code"
    t.string "openid"
    t.string "country"
    t.string "province"
    t.string "city"
    t.integer "gender"
    t.string "nick_name"
    t.string "language"
    t.string "prefecture"
    t.integer "followers_count", default: 0
    t.integer "following_count", default: 0
    t.integer "star_posts_count", default: 0
    t.integer "state", default: 0
    t.string "identity", comment: "身份介绍"
    t.string "summary", comment: "简介"
    t.string "wechat", comment: "微信号"
    t.string "school", comment: "学校"
    t.string "labels", comment: "标签"
    t.string "company", comment: "公司"
    t.string "company_address", comment: "公司地址"
    t.string "email", comment: "邮箱"
    t.string "toutiao", comment: "头条号"
    t.string "wechat_mp", comment: "公众号"
    t.string "bilibili", comment: "bilibili"
    t.string "weibo", comment: "微博"
    t.index ["cellphone", "password_digest"], name: "index_users_on_cellphone_and_password_digest", unique: true
    t.index ["cellphone"], name: "index_users_on_cellphone", unique: true
    t.index ["openid"], name: "index_users_on_openid"
  end

  create_table "white_lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "white_listable_type", null: false
    t.bigint "white_listable_id", null: false
    t.string "action"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["action", "white_listable_type", "white_listable_id"], name: "idx_action_and_able_id"
    t.index ["action"], name: "index_white_lists_on_action"
    t.index ["white_listable_type", "white_listable_id"], name: "index_white_lists_on_white_listable_type_and_white_listable_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "articles", "accounts"
  add_foreign_key "articles", "apps"
  add_foreign_key "boards", "apps"
  add_foreign_key "boards", "users"
  add_foreign_key "comments", "apps"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "comments", column: "reply_to_id"
  add_foreign_key "comments", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "products", "users"
  add_foreign_key "reports", "users"
  add_foreign_key "sections", "apps"
end
