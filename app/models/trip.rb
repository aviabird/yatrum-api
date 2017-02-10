# == Schema Information
#
# Table name: trips
#
#  id                      :integer          not null, primary key
#  name                    :string
#  description             :text
#  status                  :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#

class Trip < ApplicationRecord
  acts_as_taggable
  acts_as_votable

  has_many :places
  belongs_to :user, required: false # http://stackoverflow.com/a/39584972/1930053

  accepts_nested_attributes_for :places, :allow_destroy => true

  def toggle_like(user)
    if voted_on_by? user
      unliked_by user
    else
      liked_by user
    end
  end
end
