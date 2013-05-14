class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :topic_id
      t.integer :comment_id, :default => 0
      t.string :uname
      t.string :ip
      t.text :content

      t.timestamps
    end
  end
end
