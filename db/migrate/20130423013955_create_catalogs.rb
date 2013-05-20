class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.integer :parent_id, :default => 0
      t.integer :sortrank, :default => 0
      t.string :name
      t.string :cdir
      t.string :extra
    end
  end
end
