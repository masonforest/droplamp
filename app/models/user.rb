class User < ActiveRecord::Base
  def self.create_with_omniauth(auth) 
   puts auth 
    create do |user|  
      user.provider = auth["provider"]  
      user.uid = auth["uid"]  
      user.name = auth["user_info"]["name"]
      user.dropbox_token = auth["credentials"]["token"]
      user.dropbox_token_secret = auth["credentials"]["secret"] 
    end 
  end
end
