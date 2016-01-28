class AddUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :img
      t.string :bio
      t.timestamps null: false
    end
  end
end
