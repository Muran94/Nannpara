class CreateBlogComments < ActiveRecord::Migration[5.1]
  def change
    create_table :blog_comments do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.references :blog_article, foreign_key: true

      t.timestamps
    end
  end
end
