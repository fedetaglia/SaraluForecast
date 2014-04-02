class Trip < ActiveRecord::Base
  has_many :steps, dependent: :destroy
  belongs_to :user
end
