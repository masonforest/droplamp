class ApplicationController < ActionController::Base
  protect_from_forgery
  asset_host = Proc.new { |source|
     "http://assets.example.com"
 }
end
