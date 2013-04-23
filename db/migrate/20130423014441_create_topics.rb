class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :catalog_id
      t.string :title
      t.string :writer
      t.string :source
      t.string :litpic
      t.integer :hits, :default => 0
      t.integer :goodpost, :default => 0
      t.integer :badpost, :default => 0
      t.integer :notpost, :default => 0
      t.string :keywords
      t.string :description
      t.integer :is_trash, :default => 0

      t.timestamps
    end
  end
end
