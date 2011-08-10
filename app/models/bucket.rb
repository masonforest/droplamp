class Bucket < ActiveRecord::Base
  belongs_to :site
  def self.create(params)
    #name=ActiveSupport::SecureRandom.hex(16)
    #GOOGLE_STORAGE.create_bucket(name)
    bucket = new(:site_id=>params[:site_id])
    bucket.save
  end
  def put(object_name,object)
    
    puts "Uploading #{self.name} to #{object_name}"
    #GOOGLE_STORAGE.put_object(self.name,object_name, {:data=>object, :headers => {:x_goog_acl => 'public-read',"Content-type"=>"text/css"}})
    #"http://commondatastorage.googleapis.com/#{self.name}/#{object_name}"
    AWS::S3::S3Object.store("#{self.site.domain}/#{object_name}",object,"kissr",:access => :public_read)
    "http://kissr.s3.amazonaws.com/#{self.site.domain}/#{object_name}"
  end
end
