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

  def create_dropbox_folder
    Dir["#{Rails.root}/templates/default/**/**"].each do |file|
      next if File.directory?(file)
      to_path=self.dropbox_folder+file.sub("#{Rails.root}/templates/default","")
      dropbox.put_file( to_path,file )
    end

    #path=self.dropbox_folder
    #puts self.user.inspect
    #Rails.root.join("templates","default")
    # TODO add put_file folder method to dropbox gem
    #dropbox.file_create_folder(path)
    #dropbox.file_create_folder(path+'/css')
    #dropbox.file_create_folder(path+'/_layouts')
    #dropbox.put_file( path+ Rails.root.join("templates","default", "index.md").to_s)
    #dropbox.put_file( Rails.root.join("templates","default",  "about.md").to_s )
    #dropbox.put_file( Rails.root.join("templates","default",  "contact.md").to_s )
    #dropbox.put_file( Rails.root.join("templates","default",  "_layouts","default.html").to_s)
    #dropbox.put_file( Rails.root.join("templates","default",  "css","style.css").to_s )
    #dropbox.put_file( Rails.root.join("templates","default",  "css","screen.css").to_s )
    
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
class KISSrFileSystem
  def initialize(site)  
    @site = site  
  end  
  
  def read_template_file(path)
    @site.dropbox.download("#{@site.path}/#{path}")
  end
end
