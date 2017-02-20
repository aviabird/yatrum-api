# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string
#  uid        :string
#  token      :string
#  secret     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AuthorizationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
