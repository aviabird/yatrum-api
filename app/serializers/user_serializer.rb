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
#  google                    :string
#  facebook                  :string
#  display_name              :string
#  facebook_url              :string
#  twitter_url               :string
#  instagram_url             :string
#  website_url               :string
#  blog_url                  :string
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :instagram_access_token, :instagram_profile_picture,
             :instagram_user_name, :profile_pic, :cover_photo, :total_followers,
             :total_following, :total_trips, :is_followed_by_current_user,
             :facebook_url, :twitter_url, :instagram_url, :website_url,
             :blog_url

  def total_followers
    object.total_followers
  end

  def total_following
    object.total_following
  end

  def total_trips
    object.total_trips
  end

  def profile_pic
    if object.profile_pic
      object.profile_pic
    else
      { url: USER_CONSTANTS["default_profic_pic_male"], public_id: "" }
    end
  end

  def cover_photo
    if object.cover_photo
      object.cover_photo
    else  
      { url: USER_CONSTANTS["default_cover_photo"], public_id: "" }
    end
  end

  def is_followed_by_current_user
    current_user = User.current
    # if(object.id == 1)
    #   binding.pry
    # end
    return false unless current_user
    return false if current_user.id == object.id
    current_user.following.pluck(:id).include?(object.id)
  end

end
