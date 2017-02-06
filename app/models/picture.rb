# == Schema Information
#
# Table name: pictures
#
#  id          :integer          not null, primary key
#  url         :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  place_id    :integer
#  public_id   :string
#

class Picture < ApplicationRecord
  belongs_to :place
end
