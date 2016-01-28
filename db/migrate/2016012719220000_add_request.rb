class AddRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :user_id
      t.string :recipient_id
      t.string :message
      t.string :status
      t.timestamps null: false
    end
  end
end
