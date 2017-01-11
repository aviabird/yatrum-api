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

class Trip < ApplicationRecord
  acts_as_taggable

  has_many :cities
  belongs_to :user, required: false # http://stackoverflow.com/a/39584972/1930053

  accepts_nested_attributes_for :cities
end
