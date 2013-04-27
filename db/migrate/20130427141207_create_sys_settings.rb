class CreateSysSettings < ActiveRecord::Migration
  def change
    create_table :sys_settings do |t|
      t.string :stype
      t.text :setting
    end
  end
end
