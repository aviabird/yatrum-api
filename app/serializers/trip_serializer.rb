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
  attributes :id, :name, :description, :created_at, :updated_at, :user_id, :is_liked_by_current_user

  has_many :cities
  belongs_to :user

  def is_liked_by_current_user
  	return false unless User.current
    object.voted_on_by? User.current    
  end

end
