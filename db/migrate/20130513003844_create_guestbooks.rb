class CreateGuestbooks < ActiveRecord::Migration
  def change
    create_table :guestbooks do |t|
      t.string :title
      t.string :info
      t.string :content
      t.string :reply

      t.timestamps
    end
  end
end
