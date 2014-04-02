class Friendship < ActiveRecord::Base
include AASM

belongs_to :user
belongs_to :friend, :class_name => 'User'


  aasm :column => 'status' do
    state :pending, :initial => true
    state :accepted
    state :denied

    event :requested do
      transitions :from => [:accepted, :pending], :to => :pending
    end

    event :accepted do
      transitions :from => [:accepted, :pending], :to => :accepted
    end

    event :reject do 
      # nothing, with reject the record will be deleted
    end

    event :deny do 
      transitions :from => :pending, :to => :denied
    end
  end


end
