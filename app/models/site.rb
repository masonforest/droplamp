require 'dropbox_sdk'
class Site < ActiveRecord::Base
  after_create :create_heroku_domain,:create_dropbox_folder
  belongs_to :user
  has_one :bucket
  has_many :pages
  belongs_to :owner, :class_name =>"User"
  validates :dropbox_folder, :presence => true


  
  def create_heroku_domain
    heroku = Heroku::Client.new("mason@stirltech.com", "password")
    puts "Adding #"+self.hostname+"#"
    heroku.add_domain(ENV['KISSR_SERVER'],self.hostname)
  end
  def refresh
    Resque.enqueue(RunJekyll,self.id) 
  end
  def create_dropbox_folder
    Dir["#{Rails.root}/templates/default/**/**"].each do |file|
      next if File.directory?(file)
      to_path=self.dropbox_folder+file.sub("#{Rails.root}/templates/default","")
      puts "putting "+to_path
      dropbox.put_file( to_path,File.new(file,"r") )
    end
  end
  def dropbox
   @dropbox ||= begin
    session=DropboxSession.new(ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET'])
    session.set_access_token(self.owner.dropbox_token,self.owner.dropbox_token_secret)
    dropbox=DropboxClient.new(session,:app_folder)
    dropbox 
   end
  end

end


