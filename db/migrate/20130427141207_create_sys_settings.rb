class CreateSysSettings < ActiveRecord::Migration
  def change
    create_table :sys_settings do |t|
      t.string :stype
      t.text :setting
    end
    
    SysSetting.create(:stype => "setting", :setting => '{"site_name":"a","site_keywords":"b","site_desc":"c"}')
    SysSetting.create(:stype => "mark", :setting => '{"opend":"opend","word":"hello","size":"20px","color":"#FF0000","pos":"CenterEast"}')
    SysSetting.create(:stype => "article_mix", :setting => '#,CopyRight
#,!@#)!(@#)(!@i!@#_!@(#)q')
    SysSetting.create(:stype => "mails", :setting => '{"server":"smtp.gmail.com","port":"25","sender":"alerts@nxyouxi.com","user":"alerts@nxyouxi.com","pass":"abcd","test":"395693519@qq.com"}')
  end
end
