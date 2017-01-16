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
  attributes :id, :name, :email, :profile_pic, :cover_photo, :instagram_profile_picture,
             :instagram_user_name
end
