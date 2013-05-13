class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.string :mark
      t.string :ad_type
      t.string :size
      t.string :info
      t.string :code

      t.timestamps
    end
  end
end
