class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
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
  def admin?
    self.name=="Mason Fischer"
  end
  def first_name
    self.name.split(' ')[0]
  end

  def last_name
    self.name.split(' ')[1..-1].join('.')
  end

end
