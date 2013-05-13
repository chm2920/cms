class CreateFriendlinks < ActiveRecord::Migration
  def change
    create_table :friendlinks do |t|
      t.string :title
      t.string :link
      t.integer :rank, :default => 0
    end
  end
end
