class Site < ActiveRecord::Base
  DOMAINS=["kissr.co","com","org","net","info"]
  before_create :heroku_add_domain
  belongs_to :user
  def self.find_by_domain(domain)
    domain = domain.split(".")
    Site.find_by_subdomain_and_domain(domain[0],domain[1..-1].join('.'))
  end
  def render(path)
    dropbox = Dropbox::Session.deserialize(self.user.dropbox_token)
    dropbox.mode = :dropbox
    path='home' if path.blank?
    if path =~ /\/(.*\..*)/
      file=$1
      puts file
      type= MIME::Types.type_for(file)
      {:content=>dropbox.download(self.path+'/'+path),:content_type => type.to_s[1..-2]}
    else
      @template = Liquid::Template.parse(dropbox.download(self.path+'/default.template'))
      @content=Redcarpet.new(dropbox.download(self.path+'/'+path+'.markdown')).to_html
      {:content=>@template.render('content' => @content),:content_type=>'text/html'}
    end 
  end
  def self.create_site_folder(path,dropbox_token)
     dropbox=Dropbox::Session.deserialize(dropbox_token)
     dropbox.mode = :dropbox
    
     
     dropbox.create_folder(path)
     dropbox.create_folder(path+'/css')
     dropbox.upload( Rails.root.join("templates", "home.markdown").to_s ,path)
     dropbox.upload( Rails.root.join("templates", "about.markdown").to_s ,path)
     dropbox.upload( Rails.root.join("templates", "contact.markdown").to_s ,path)
 
    dropbox.upload( Rails.root.join("templates", "default.template").to_s ,path)
     dropbox.upload( Rails.root.join("templates", "css","style.css").to_s ,path+'/css')
     dropbox.upload( Rails.root.join("templates", "css","screen.css").to_s ,path+'/css')
 
  end
  def heroku_add_domain
    heroku = Heroku::Client.new("moocowmason@gmail.com", "password")
    heroku.add_domain("kissr","#{self.subdomain}.#{self.domain}")
  end
#  def dropbox
#   @dropbox ||= begin
#    Dropbox::Session.deserialize(self.dropbox_token)
#    dropbox.mode = :dropbox
#   end
#  end
end
