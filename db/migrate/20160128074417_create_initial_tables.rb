class CreateInitialTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.string :img_path
      t.string :bio
      t.timestamps null: false
    end

    create_table :match_requests do |t|
      t.belongs_to :user, null: false
      t.references :match
      t.string :category, null: false # singles, doubles
      t.string :status  #nil, "failed", "accepted"
      t.string :message
      t.timestamps null: false
    end

    create_table :match_invites do |t|
      t.belongs_to :match_request, index: true, null: false
      t.belongs_to :user, index: true, null: false
      t.string :team, null: false
      t.boolean :accept # null, true, false
    end

    create_table :matches do |t|
      t.references :match_request
      t.string :status # set (default), cancelled, over
      t.timestamps null: false
    end

    create_table :match_results do |t|
      t.belongs_to :match, index: true, null: false
      t.belongs_to :user, index: true, null: false
      t.string :team, null: false # 1, 2, or custom team name
      t.integer :result # -1: loss, 0: cancelled, 1: win
    end

  end
end
