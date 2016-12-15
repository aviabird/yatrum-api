class AddInstagramProfilePictureToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :instagram_profile_picture, :string
  end
end
