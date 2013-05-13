class CreateSysSettings < ActiveRecord::Migration
  def change
    create_table :sys_settings do |t|
      t.string :stype
      t.text :setting
    end
    
    SysSetting.create(:stype => "setting", :setting => "")
    SysSetting.create(:stype => "mark", :setting => "")
    SysSetting.create(:stype => "article_mix", :setting => "#,CopyRight\r\n#,!@#)!(@#)(!@i!@#_!@(#)q")
    SysSetting.create(:stype => "mails", :setting => "")
  end
end
