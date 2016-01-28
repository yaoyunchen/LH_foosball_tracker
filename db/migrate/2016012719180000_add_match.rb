class AddMatch < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :user1_id
      t.string :user2_id
      t.string :winner_id
      t.string :loser_id
      t.string :request_id
      t.timestamps null: false
    end
  end
end
