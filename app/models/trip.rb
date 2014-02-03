class Trip < ActiveRecord::Base
  has_many :steps
end
