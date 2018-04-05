class AddTweetNicesCountToTweets < ActiveRecord::Migration[5.1]
  def self.up
    add_column :tweets, :tweet_nices_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :tweets, :tweet_nices_count
  end
end
