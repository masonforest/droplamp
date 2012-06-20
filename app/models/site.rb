require 'dropbox_sdk'
class Site < ActiveRecord::Base
  after_create :create_heroku_domain, :if => Proc.new { |site| site.domain.free? }
  after_create :create_dropbox_folder, :if => Proc.new { |site| site.domain.free? }

  after_destroy :remove_heroku_domain

  belongs_to :owner, :class_name =>"User"
  validates :dropbox_folder, :presence => true
  has_one :domain, :dependent => :destroy
  has_one :subscription, :dependent => :destroy
  accepts_nested_attributes_for :domain

  
  def create_heroku_domain
    heroku = Heroku::Client.new(ENV['HEROKU_USERNAME'],ENV['HEROKU_PASSWORD'])
    heroku.add_domain(ENV['KISSR_SERVER'],self.domain.to_s)# if Rails.env.eql? 'production'
    if not self.domain.free?
      heroku.add_domain(ENV['KISSR_SERVER'],self.domain.to_s+".kissr.com")
    end
  end
  def remove_heroku_domain
    heroku = Heroku::Client.new(ENV['HEROKU_USERNAME'],ENV['HEROKU_PASSWORD'])
    puts "Removing #"+self.domain.to_s
    heroku.remove_domain(ENV['KISSR_SERVER'],self.domain.to_s)# if Rails.env.eql? 'production'
  end

  def refresh
  end
  def create_dropbox_folder
    Dir["#{Rails.root}/templates/default/**/**"].each do |file|
      next if File.directory?(file)
      to_path=self.dropbox_folder+file.sub("#{Rails.root}/templates/default","")
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


