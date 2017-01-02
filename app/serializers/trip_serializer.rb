# == Schema Information
#
# Table name: trips
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  status      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#

class TripSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :created_at, :updated_at, :user_id, :profile_pic_url

  has_many :cities

  def profile_pic_url
    object.user.profile_pic? ? object.user.profile_pic[:url] : nil
  end

end
