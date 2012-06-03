class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  after_create :create_stripe_user,:notify_admin
  
  belongs_to :reffered_by, class_name: "User"
  has_many :sites, foreign_key: "owner_id"
  has_many :subscriptions, :through => :sites

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  # Setup accessible (or protected) attributes for your model
  #attr_accessible :provider,:uid, :password, :password_confirmation, :remember_me
 
  def self.create_with_omniauth(auth,reffered_by_id)
    create do |user|
      user.provider = auth['provider']
      user.reffered_by_id=reffered_by_id
      user.uid = auth['uid'].to_s
      user.dropbox_token=auth['extra']['access_token'].token
      user.dropbox_token_secret=auth['extra']['access_token'].secret
      user.name = auth['info']['name'] if auth['info']['name']
      user.password="password"
      user.email = auth['info']['email'] if auth['info']['email']
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
  def notify_admin
    puts "notifying admin!"
    AdminMailer.signup(self.id).deliver
  end
  def update_stripe_card(token)
    customer = Stripe::Customer.retrieve(stripe_customer_id)
    customer.card = token
    customer.save
    update_attribute(:stored_stripe_card, true)
  end
  def create_stripe_user
    update_attribute(:stripe_customer_id, Stripe::Customer.create(:description => email).id)
  end
  def credit(amount)
    update_attribute(:balance, balance + amount)
  end
  def charge(amount)
    update_attribute(:balance, balance - amount)
    if balance < -50
      Stripe::Charge.create(
        :amount => -balance,
        :currency => "usd",
        :customer => stripe_customer_id
      )
      puts "charged #{-balance} to #{email}"
      update_attribute(:balance, 0)
    end
  end

end
