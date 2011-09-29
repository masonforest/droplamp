class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  # Setup accessible (or protected) attributes for your model
  #attr_accessible :provider,:uid, :password, :password_confirmation, :remember_me
 
  def self.create_with_omniauth(auth)
    puts 'still alive!'
    puts auth['provider']
    puts auth['uid']
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
     # if auth['user_info']
     #   user.name = auth['user_info']['name'] if auth['user_info']['name'] # Twitter, Google, Yahoo, GitHub
     #   user.email = auth['user_info']['email'] if auth['user_info']['email'] # Google, Yahoo, GitHub
     # end
     # if auth['extra'] && auth['extra']['user_hash']
     #   user.name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name'] # Facebook
    #    user.email = auth['extra']['user_hash']['email'] if auth['extra']['user_hash']['email'] # Facebook
    #  end
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
