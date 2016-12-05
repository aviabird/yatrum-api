# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  country    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trip_id    :integer
#

class City < ApplicationRecord
  has_many :places
  belongs_to :trip

  # accepts_nested_attributes_for :places

end
