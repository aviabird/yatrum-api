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

  validates_uniqueness_of :email
  validates_length_of :password, minimum: 4, maximum: 32

  after_create :subscribe_user_to_mailing_list

  def full_name
    name
  end

  def total_followers
    followers.count
  end

  def total_following
    following.count
  end

  def total_trips
    trips.count
  end

  def is_following?(id)
    following.pluck(:id).include?(id)
  end

  def toggle_follow(followed_id)
    if is_following?(followed_id.to_i)
      id = Relationship.find_by(follower_id: self.id, followed_id: followed_id).id
      Relationship.delete(id)
    else
      active_relationships.create(followed_id: followed_id)
    end
  end

  def self.current=(user)
    Thread.current[:current_user] = user
  end

  def self.current
    Thread.current[:current_user]
  end

  private

  def subscribe_user_to_mailing_list
    SubscribeUserToMailingListJob.perform_later(self)
  end
end
