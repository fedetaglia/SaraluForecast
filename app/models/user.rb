class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  
  validates :username, presence: true
  
  has_many :trips, dependent: :destroy

  # managing friendship

  has_many :friendships , -> { where status: 'accepted' }, dependent: :destroy
  has_many :friends, :through => :friendships

  has_many :inverse_friendships, -> { where status: 'accepted' }, :class_name => 'Friendship', :foreign_key => 'friend_id' , dependent: :destroy
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  
  #request I made and not accepted yet
  has_many :pending_friendships, -> { where status: 'pending' }, :class_name => 'Friendship', :foreign_key => 'user_id'
  has_many :requested_friends, :through => :pending_friendships, :source => :friend

  #request received and not accepted yet
  has_many :inverse_pending_friendships, -> { where status: 'pending' }, :class_name =>'Friendship', :foreign_key => 'friend_id'
  has_many :requesting_friends, :through => :inverse_pending_friendships, :source => :user


  # facebook authentication

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where( provider: auth.provider, uid: auth.uid).first
    if !user
      registered_user = User.where( email: auth.info.email).first
      if registered_user
        user = registered_user
      else
        user = User.create(username:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20],
                          )
      end    
    end
    add_fb_friends(user, auth);
    user
  end


  def self.add_fb_friends(user,auth)
    
    koala = Koala::Facebook::API.new(auth.credentials.token,ENV['FB_APP_KEY'])
    fb_friend = koala.get_connections('me','friends')
    fb_ids = fb_friend.map { |obj| obj['id'] }
    friends = User.where( uid: fb_ids)
    if friends.length > 0
      friends.each do |friend|
        if !user.friends.include? friend
          friendship = user.friendships.build( friend_id: friend.id)
          inverse_friendship = user.inverse_friendships.build( user_id: friend.id )
          friendship.accepted
          inverse_friendship.accepted
          friendship.save
          inverse_friendship.save
        end
      end
    end
  end

end
