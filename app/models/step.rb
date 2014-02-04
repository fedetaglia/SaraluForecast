class Step < ActiveRecord::Base
  belongs_to :trip
  has_and_belongs_to_many :forecasts
end
