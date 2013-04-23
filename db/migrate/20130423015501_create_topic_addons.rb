class CreateTopicAddons < ActiveRecord::Migration
  def change
    create_table :topic_addons do |t|
      t.integer :topic_id
      t.text :content

      t.timestamps
    end
  end
end
