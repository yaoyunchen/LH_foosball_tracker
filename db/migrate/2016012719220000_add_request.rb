class AddRequest < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.integer :recipient_id
      t.string :status
      t.string :message
      t.timestamps null: false
    end
  end
end
