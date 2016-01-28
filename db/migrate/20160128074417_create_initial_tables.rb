class CreateInitialTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.string :bio
      t.timestamps null: false
    end

    create_table :match_requests do |t|
      t.references :user, null: false
      t.references :match
      t.string :message
      t.timestamps null: false
    end

    create_table :matches do |t|
      t.references :match_request
      t.string :status, default: 'set' # set (default), cancelled, over
      t.timestamps null: false
    end

    create_table :match_players do |t|
      t.belongs_to :match, index: true, null: false
      t.belongs_to :user, index: true, null: false
      t.string :match_type, null: false # singles, doubles
      t.integer :result
    end

    create_table :match_invites do |t|
      t.belongs_to :request, index: true, null: false
      t.belongs_to :user, index: true, null: false
      t.boolean :accept_invite # true, false
    end

    # create_join_table :matches, :users do |t|
    #   t.index :match_id
    #   t.index :user_id
    #   t.string :match_type, null: false # singles, doubles
    #   t.integer :result
    # end

    # create_join_table :requests, :users do |t|
    #   t.index :request_id
    #   t.index :user_id
    #   t.boolean :accept_invite # true, false
    # end

  end
end
