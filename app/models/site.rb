require 'liquid_inheritance'
require 'pathname'
require 'aws/s3'

class Site < ActiveRecord::Base
  DOMAINS=["kissr.co","com","org","net","info"]
  before_create :heroku_add_domain#,:add_bucket
  belongs_to :user
  include Redis::Objects
  hash_key :cache, :marshal => true 
  
  def render(path)
    path='home' if path.blank?
    Liquid::Template.file_system = KISSrFileSystem.new(self)
    
      content=get(path+'.html')   
      template = Liquid::Template.parse(content)
      content = template.render('content' => content)#, 'galleries' => {'practice'=>list_directory(self.path+"/galleries/practice")})
      content=offload_assets(content)
      url=self.subdomain+"."+self.domain+path
    
    { :content => content, :content_type => 'text/html'}
 
  end
  def offload_assets_css(css)
    puts "alive"
    css.scan(/url\((.*)\)/).each do |url|
  if not expired?(url[0].to_s)
    
  AWS::S3::S3Object.store(url[0].to_s,get(url[0].to_s),"kissr-macc",:access => :public_read)
    end  
  end
    css.gsub(/url\((.*)\)/,'url(http://s3.amazonaws.com/kissr-MACC\1)')
  end
  def offload_assets(content)
    doc = Nokogiri::HTML(content)
    doc.css('script,img').each do |image|
      puts image
      if not image['src'].to_s =~ /^http:\/\//  then
      if not image['src'].blank? then      
        if  expired?(image['src'])
          AWS::S3::S3Object.store(image['src'].to_s,get(image['src'].to_s),"kissr-macc",:access => :public_read)
        end
  
         image['src']='http://s3.amazonaws.com/kissr-macc'+image['src'].to_s
        end
      end
    end
    doc.css('link').each do |image|
      puts image
      if not image['href'].to_s =~ /^http:\/\//  then
        if expired?(image['src']) then
          AWS::S3::S3Object.store(image['href'].to_s,get(image['href'].to_s),"kissr-macc",:access => :public_read)
        end
        image['href']='http://s3.amazonaws.com/kissr-macc'+  image['href'].to_s
      end
    end

    doc.to_s
  end
  def list_directory(path)
    dropbox=Dropbox::Session.deserialize(self.user.dropbox_token)
    dropbox.mode = :dropbox
    dropbox.list(path).map{|file| Pathname.new(file.path).basename.to_s}
  end
  def expired?(path)
   dropbox=Dropbox::Session.deserialize(self.user.dropbox_token)
   dropbox.mode = :dropbox
    path=path.to_s.gsub(/^\//,"")
    path=self.path+'/'+path
    url=self.subdomain+"."+self.domain+path
   (cache[url].nil?) or  dropbox.metadata(path).modified >  cache[url][:modified]
  end
  def get(path,use_cache=nil)
    dropbox=Dropbox::Session.deserialize(self.user.dropbox_token)
    dropbox.mode = :dropbox
    path=path.to_s.gsub(/^\//,"")
    path=self.path+'/'+path
    url=self.subdomain+"."+self.domain+path
    begin
      if not expired?(path) then 
        cache[url][:content]  
      else
        content=dropbox.download(path)
        cache[url]={:modified=>dropbox.metadata(path).modified,:content=>content}
        content
    end
      rescue Dropbox::UnsuccessfulResponseError
      nil
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
class KISSrFileSystem
  def initialize(site)  
    @site = site  
  end  
  
  def read_template_file(path)
    @site.get(path)
  end
end

