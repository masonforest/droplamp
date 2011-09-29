class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  # Setup accessible (or protected) attributes for your model
  #attr_accessible :provider,:uid, :password, :password_confirmation, :remember_me
 
  def self.create_with_omniauth(auth)
    puts 'still alive!'
    puts auth.inspect
    #pp auth['extra']['access_token'].token
    create do |user|
      user.provider = auth['provider']
      user.uid = auth['uid'].to_s
      user.dropbox_token=auth['extra']['access_token'].token
      user.dropbox_token_secret=auth['extra']['access_token'].secret
      user.name = auth['info']['name'] if auth['info']['name']
      #puts auth.inspect
      #if auth['info']
      #  user.name = auth['info']['name'] if auth['info']['name'] # Twitter, Google, Yahoo, GitHub
      #  user.email = auth['info']['email'] if auth['info']['email'] # Google, Yahoo, GitHub
      #end

    end
  end

  def admin?
    self.name=="Mason Fischer"
  end
  def first_name
    self.name.nil? ? "" : self.name.split(' ')[0]
  end

  def last_name
    self.name.split(' ')[1..-1].join('.')
  end

end
