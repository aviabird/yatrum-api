# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  name                      :string
#  email                     :string
#  password_digest           :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  instagram_access_token    :string
#  instagram_user_name       :string
#  instagram_profile_picture :string
#  profile_pic               :text
#  cover_photo               :text
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :instagram_user_name, :instagram_profile_picture, 
             :instagram_access_token, :profile_pic, :cover_photo, :total_followers,
             :total_following, :total_trips

  def total_followers
    object.total_followers
  end

  def total_following
    object.total_following
  end

  def total_trips
    object.total_trips
  end

end

