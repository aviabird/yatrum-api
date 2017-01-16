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

class User < ApplicationRecord
  has_secure_password
  serialize :profile_pic 
  serialize :cover_photo

  has_many :trips
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  def full_name
    name
  end

  def total_followers
    followers.count
  end

  def total_following
    following.count
  end

end
