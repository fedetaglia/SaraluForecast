class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  
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


  # facebook authentication

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where( email: auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(username:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20],
                          )
      end    
    end
  end

end
