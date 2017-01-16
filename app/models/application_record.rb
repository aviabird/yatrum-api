class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  serialize :metadata, Oj
end
