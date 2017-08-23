class CreateUsers < ActiveRecord::Migration[5.1]
  def up
    create_table :users do |t|
      t.column :name, :string
      t.column :email, :string
      t.column :password_digest, :string
      t.column :profile_picture, :string
      t.column :age, :integer
      t.timestamps
    end
  end
  def down
    drop_table :users
  end
end
