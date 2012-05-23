require 'vcr'

VCR.configure do |c|
  c.stub_with :webmock
  c.ignore_request do |request|
    URI(request.uri).host == "127.0.0.1"
  end
  
  c.cassette_library_dir     = 'features/cassettes'
  c.default_cassette_options = { :record => :new_episodes }
end

VCR.cucumber_tags do |t|
  t.tag  '@dropbox_request' 
end

