class Site < ActiveRecord::Base
  DOMAINS=["kissr.co","com","org","net","info"]
  before_create :heroku_add_domain
  belongs_to :user
  include Redis::Objects
  hash_key :cache, :marshal => true 
  def render(path)
    path='home' if path.blank?
    if path =~ /\/(.*\..*)/
      type = MIME::Types.type_for($1).to_s[1..-2] # for some reason MIME::Types wraps the type in []'s
      { :content => get(self.path+'/'+path), :content_type => type }
    else
      @template = Liquid::Template.parse(get(self.path+'/default.template'))
      @content=Redcarpet.new(get(self.path+'/'+path+'.markdown')).to_html
      { :content => @template.render('content' => @content), :content_type => 'text/html'}
    end
  end
  def get(path)
  dropbox=Dropbox::Session.deserialize(self.user.dropbox_token)
  dropbox.mode = :dropbox
  url=self.subdomain+"."+self.domain+"/"+path
  if (not cache[url].nil?) and  dropbox.metadata(path).modified <=  cache[url][:modified]
    cache[url][:content]  
  else
    content=dropbox.download(path)
    cache[url]={:modified=>dropbox.metadata(path).modified,:content=>content}
    content
  end
 end
 def self.find_by_domain(domain)
    domain = domain.split(".")
    Site.find_by_subdomain_and_domain(domain[0],domain[1..-1].join('.'))
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
