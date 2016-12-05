# == Schema Information
#
# Table name: places
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  review      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  city_id     :integer
#

require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
