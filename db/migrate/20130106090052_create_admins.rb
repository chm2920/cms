class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :adminname
      t.string :password
      t.string :level

      t.timestamps
    end
    
    Admin.create(:adminname => "admin", :password => "21232f297a57a5a743894a0e4a801fc3")
  end
end
