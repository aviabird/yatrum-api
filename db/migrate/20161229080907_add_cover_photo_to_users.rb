class AddCoverPhotoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cover_photo, :text
  end
end
