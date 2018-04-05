class CreateTweetComments < ActiveRecord::Migration[5.1]
  def change
    create_table :tweet_comments do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.references :tweet, foreign_key: true

      t.timestamps
    end
  end
end
