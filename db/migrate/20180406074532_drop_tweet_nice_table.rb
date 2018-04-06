class DropTweetNiceTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :tweet_nices
  end
end
