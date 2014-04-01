class AddFriendshipTable < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.string  :status
      t.timestamps
    end
  end
end