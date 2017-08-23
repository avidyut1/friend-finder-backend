class CreateDislikes < ActiveRecord::Migration[5.1]
  def change
    create_table :dislikes do |t|
      t.column :first_user_id, :integer
      t.column :second_user_id, :integer
      t.timestamps
    end
    add_index :dislikes, [:first_user_id, :second_user_id]
  end
end
