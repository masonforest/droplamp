class Site < ActiveRecord::Base
  after_create :create_heroku_domain,:create_dropbox_folder
  belongs_to :user
  has_one :bucket
  has_many :pages
  belongs_to :owner, :class_name =>"User"


  def self.find_by_domain(domain)
    domain = domain.gsub(/www\./,"").split(".")
    puts domain.inspect
    Site.joins(:domain).where("domains.domain"=>domain[0], "domains.tld"=>domain[1..-1].join('.')).first
  end
  def render(path)
    path ||= "index"
    Page.find_or_create_by_path_and_site_id(path,self.id).render
    
    end
  
  def create_heroku_domain
    heroku = Heroku::Client.new("mason@stirltech.com", "password")
    puts "Adding #"+self.hostname+"#"
    heroku.add_domain(ENV['KISSR_SERVER'],self.hostname)
  end

  def create_dropbox_folder
    path=self.path
    puts self.user.inspect
    # TODO add upload folder method to dropbox gem
    dropbox.create_folder(path)
    dropbox.create_folder(path+'/css')
    dropbox.create_folder(path+'/_layouts')
    dropbox.upload( Rails.root.join("templates","default", "index.md").to_s ,path)
    dropbox.upload( Rails.root.join("templates","default",  "about.md").to_s ,path)
    dropbox.upload( Rails.root.join("templates","default",  "contact.md").to_s ,path)
    dropbox.upload( Rails.root.join("templates","default",  "_layouts","default.html").to_s ,path)
    dropbox.upload( Rails.root.join("templates","default",  "css","style.css").to_s ,path+'/css')
    dropbox.upload( Rails.root.join("templates","default",  "css","screen.css").to_s ,path+'/css')
    
  end
  def dropbox
   @dropbox ||= begin
    dropbox=Dropbox::Session.new('69vdq9pk8stjkb8', '6gc7j0bdw85uzoh')
    dropbox.set_access_token(self.owner.dropbox_token,self.owner.dropbox_token_secret)
    dropbox.mode = :dropbox
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
