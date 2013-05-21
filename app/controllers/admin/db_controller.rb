#encoding: utf-8
class Admin::DbController < Admin::Backend
  
  def index
    @path = Rails.root.join("db", "backup")
    @file_list = []
    Dir.foreach(@path) do |filename|
      hash = {}
      if filename != "." and filename != ".." and filename != ".DS_Store"
        file = @path + filename
        hash[:filesize] = File.size(file)
        hash[:filename] = filename
        hash[:datetime] = File.mtime(file).to_s(:db)
        @file_list << hash
      end
    end
    @file_list.sort! {|b, a| a[:filename] <=> b[:filename]}
  end

  def backup
    case request.method
    when "POST"
      config = Rails.configuration.database_configuration[Rails.env]
      FileUtils.cp(Rails.root.join(config["database"]), Rails.root.join("db", "backup", Time.now.strftime("%Y-%m-%d_%H-%M-%S") + ".sqlite3"))           
    end
    redirect_to :action => "index" 
  end
  
  def restore 
    case request.method
    when "POST"   
      @path = Rails.root.join("db", "backup")
      config = Rails.configuration.database_configuration[Rails.env]
      FileUtils.cp(@path.join(params[:f]), Rails.root.join(config["database"]))
    end
    redirect_to :action => "index"
  end
  
  def destroy
    case request.method
    when "POST"
      @path = Rails.root.join("db", "backup")
      File.delete(@path.join(params[:f]))
    end
    redirect_to :action => "index"  
  end
  
  def tables
    @tables = ActiveRecord::Base.connection.exec_query("select * from sqlite_master where type='table'")
  end
  
  def export_sql
    case request.method
    when "POST"
      @table = params[:table]
      @columns = params[:columns]
      @result = ActiveRecord::Base.connection.exec_query("select #{@columns.join(',')} from #{@table}")
      @rows = @result.rows
      @columns = @result.columns
      
      @sql = []
      @rows.each do |r|
        t = []
        r.each do |c|
          if c.nil?
            c = ""
          end
          if c.is_a?(Integer) 
            t << c
          else
            c = c.gsub("'", "‘")
            t << "'" + c + "'"
          end
        end
        @sql << "INSERT INTO #{@table} VALUES(" + t.join(",") + ");"
      end
      @sql = @sql.join("\n")
    end    
  end
  
  def structure
    @table = params[:table]
    @structure = ActiveRecord::Base.connection.exec_query("PRAGMA table_info(#{@table})", 'SCHEMA').to_hash
  end
  
  def sql
    case request.method
    when "POST"
      # begin
        @sql = params[:x]
        if !@sql.blank?
          @result = []
          sqls = @sql.split(";")
          sqls.each do |sql|
            begin
              t = ActiveRecord::Base.connection.exec_query(sql).to_hash
              @result << t
            rescue
            else             
            end
          end
        end
      # rescue
        # @result = "sql error"
      # else
      # end
    end
  end
  
end
