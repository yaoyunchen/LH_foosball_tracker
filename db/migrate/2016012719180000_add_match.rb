class AddMatch < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :request_id
      t.integer :user1_id
      t.integer :user2_id
      t.integer :winner_id
      t.integer :loser_id
      t.string :status
      t.timestamps null: false
    end
  end
end
