require 'gstore'
require 'kconv'
GOOGLE_STORAGE = GStore::Client.new :access_key => ENV['GOOGLE_STORAGE_KEY'], :secret_key =>ENV['GOOGLE_STORAGE_SECRET'] 
