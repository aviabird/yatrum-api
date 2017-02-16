# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  name                      :string
#  email                     :string           default(""), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  instagram_access_token    :string
#  instagram_user_name       :string
#  instagram_profile_picture :string
#  profile_pic               :text
#  cover_photo               :text
#  role_id                   :integer
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :inet
#  last_sign_in_ip           :inet
#

class User < ApplicationRecord
  # has_secure_password

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
  
  belongs_to :role

  validates_uniqueness_of :email
  validates_length_of :password, minimum: 4, maximum: 32

  after_create :subscribe_user_to_mailing_list, :send_welcome_email

# Roles of a User
  ROLES = {
    admin: 'admin',
    user:  'user'
  }.freeze

  # Check if user is Admin or not
  def admin?
    role.try(:name).eql? ROLES[:admin]
  end

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

  # TODO: Use perform_later instead of perform_now
  # But currenttly we dnot have any delay job worker like sidekiq...
  # intergate sidekiq
  def subscribe_user_to_mailing_list
    SubscribeUserToMailingListJob.perform_now(self)
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
end
