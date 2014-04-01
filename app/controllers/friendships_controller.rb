class FriendshipsController < ApplicationController


def create
  @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
  @friendship.requested
  # friend = User.find_by_id params[:friend_id]
  # @inverse_friendship = friend.friendships.build(:friend_id => current_user.id)
  if @friendship.save # && @inverse_friendship.save
    flash[:notice] = "Friendship request has been sent"
  else
    flash[:notice] = "Unable to sent the request"
  end 
  redirect_to users_path
end

def update
  if params[:commit] == 'Accept'
    # accept friendship
    # find the inverse_friendship and requesting friend
    inverse_friendship = current_user.inverse_pending_friendships.find_by_id params[:id]
    requesting_friend = inverse_friendship.user
    # create the inverse_friendship and initialize it to 'pending'
    friendship = current_user.friendships.build(:friend_id => requesting_friend.id)
    friendship.accepted
    inverse_friendship.accepted
    # saving the friendship and change the status of the 2 sides to accepted
    if friendship.save && inverse_friendship.save
      flash[:notice] = ("#{requesting_friend.username} has been added to your friends")
      # should redirect either profile or list
      redirect_to users_path
    end
  
  elsif params[:commit] == 'Deny'
    # deny friendship
    # create the inverse_friendship
    # modify friendship and inverse_friendship status, the user cannot see you anymore
  else
    # what are you looking for?
  end

end

def destroy
  if params[:commit] == 'Reject'
    # reject a pending request from an other user
    @friendship = current_user.inverse_pending_friendships.find_by_id params[:id]
    
    if @friendship.destroy # && @inverse_friendship.destroy
        flash[:notice] = "Friendship removed"
    else
        flash[:notice] = 'Unable to delete friendship'
    end
  end

  if params[:commit] == 'Cancel'
    # cancel a friendship request made by current_user
    @friendship = current_user.pending_friendships.find_by_id params[:id]
    if @friendship.destroy 
        flash[:notice] = "request removed"
    else
        flash[:notice] = 'Unable to delete friendship'
    end
  end

  if params[:commit] == 'Remove'
    # remove from an actual friend
    friendship = current_user.friendships.find_by_id params[:id]
    friend = friendship.friend
    inverse_friendship = current_user.inverse_friendships.find_by_user_id_and_friend_id(friend.id,current_user.id)
    
    if friendship.destroy && inverse_friendship.destroy
      flash[:notice] = ("#{friend.username} removed from your friends")
    end
  end 
  

  redirect_to users_path
end


end



# aasm to manage the status
#
# https://github.com/aasm/aasm