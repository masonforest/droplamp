class Site < ActiveRecord::Base
  SUBDOMAINS=["kissr.co"]
  def after_create
    heroku = Heroku::Client.new("moocowmason@gmail.com", "password")
    heroku.add_domain("kissr","#{self.subdomain}.#{self.domain}")
  end
end
