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
#  google                    :string
#  facebook                  :string
#  display_name              :string
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

  # after_create :subscribe_user_to_mailing_list, :send_welcome_email

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

  def self.for_oauth oauth
    oauth.get_data
    data = oauth.data

    user = find_by(oauth.provider => data[:id]) || find_or_create_by(email: data[:email]) do |u|
      u.password = SecureRandom.hex
    end

    user.update(
      display_name: oauth.get_names.join(' '),
      email: data[:email],
      oauth.provider => data[:id]
    )

    user
  end

  # For Social oAuth
  # ==========================================================
  def self.from_auth(params, current_user)
    params = params.with_indifferent_access
    authorization = Authorization.find_or_initialize_by(provider: params[:provider], uid: params[:uid])
    if authorization.persisted?
      if current_user
        if current_user.id == authorization.user.id
          user = current_user
        else
          return false
        end
      else
        user = authorization.user
      end
    else
      if current_user
        user = current_user
      elsif params[:email].present?
        user = User.find_or_initialize_by(email: params[:email])
      else
        user = User.new
      end
    end
    authorization.secret = params[:secret]
    authorization.token  = params[:token]
    fallback_name        = params[:name].split(" ") if params[:name]
    fallback_first_name  = fallback_name.try(:first)
    fallback_last_name   = fallback_name.try(:last)

    # Note: To be added Latter
    #========================= 
    # user.first_name    ||= (params[:first_name] || fallback_first_name)
    # user.last_name     ||= (params[:last_name]  || fallback_last_name)

    # User PaperCLip here with Image Model
    # ====================================
    # if user.image_url.blank?
    #   user.image = Image.new(name: user.full_name, remote_file_url: params[:image_url])
    # end

    # user.password = Devise.friendly_token[0,10] if user.encrypted_password.blank?
    user.password = SecureRandom.hex if user.password_digest.blank?

    # In case of twitter authentication
    # But this will be removed
    if user.email.blank?
      user.save(validate: false)
    else
      user.save
    end
    authorization.user_id ||= user.id
    authorization.save
    user
  end


  def displayName= name
    self.display_name = name
  end

  # ==========================================================
end
