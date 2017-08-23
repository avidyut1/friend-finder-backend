class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes, :id => false do |t|
      t.column :first_user_id, :integer
      t.column :second_user_id, :integer
      t.timestamps
    end
    add_index :likes, [:first_user_id, :second_user_id]
  end
end
