class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates :username, presence: true
  
  has_many :trips

  # managing friendship

  has_many :friendships , -> { where status: 'accepted' }
  has_many :friends, :through => :friendships

  has_many :inverse_friendships, -> { where status: 'accepted' }, :class_name => 'Friendship', :foreign_key => 'friend_id' 
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  
  #request I made and not accepted yet
  has_many :pending_friendships, -> { where status: 'pending' }, :class_name => 'Friendship', :foreign_key => 'user_id'
  has_many :requested_friends, :through => :pending_friendships, :source => :friend

  #request received and not accepted yet
  has_many :inverse_pending_friendships, -> { where status: 'pending' }, :class_name =>'Friendship', :foreign_key => 'friend_id'
  has_many :requesting_friends, :through => :inverse_pending_friendships, :source => :user

end
