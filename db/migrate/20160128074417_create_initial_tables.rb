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


    create_table :matches do |t|
      t.belongs_to :user, null: false
      t.string :category, null: false # singles, doubles
      t.string :status # set (default), cancelled, over
      t.string :message
      t.timestamps null: false
    end


    create_table :match_invites do |t|
      t.belongs_to :match, index: true, null: false
      t.belongs_to :user, index: true, null: false
      t.string :side, null: false
      t.boolean :accept # null, true, false
      t.timestamps null: false
    end


    create_table :singles_results do |t|
      t.belongs_to :match, index: true, null: false
      t.belongs_to :user, index: true, null: false
      t.string :side, null: false
      t.integer :win
      t.integer :loss
    end


    create_table :doubles_results do |t|
      t.belongs_to :match, index: true, null: false
      t.belongs_to :team, index: true, null: false
      t.integer :win
      t.integer :loss
    end

    create_table :teams do |t|
      t.string :members
    end
  end
end
