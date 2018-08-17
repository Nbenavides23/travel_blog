class CreatePost < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :user_id
      t.string :title
      t.text   :text_content
      t.date   :posts_date
      t.string :image
    end
  end
end
