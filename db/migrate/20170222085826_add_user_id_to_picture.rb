class AddUserIdToPicture < ActiveRecord::Migration[5.0]
  def up
    add_reference :pictures, :user, index: true

    # Add User Reference to previously created Pictures
    User.all.each do |user|
      user.trips.each do |trip|
        trip.places.each do |place|
          place.pictures.each do |pic|
            puts "adding user id #{user.id} to #{pic.id}"
            pic.user_id = user.id
            pic.save
          end
        end
      end    
    end
  end

  def down
    remove_column :pictures, :user_id
  end
end
