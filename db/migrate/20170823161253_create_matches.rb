class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.column :first_user_id, :integer
      t.column :second_user_id, :integer
      t.timestamps
    end
  end
end
