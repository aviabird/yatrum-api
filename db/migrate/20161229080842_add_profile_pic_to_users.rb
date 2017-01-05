class AddProfilePicToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :profile_pic, :text
  end
end
