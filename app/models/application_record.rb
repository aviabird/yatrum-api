class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  serialize :preferences, Oj
end
