class AddInstagramUserNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :instagram_user_name, :string
  end
end
