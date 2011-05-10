class ApplicationController < ActionController::Base
  include Clearance::Authentication
  protect_from_forgery
  asset_host = Proc.new { |source|
     "http://assets.example.com"
 }
end
