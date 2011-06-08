project_type = :rails
project_path = Compass::AppIntegration::Rails.root
http_path = "/"
sass_dir = "app/views/stylesheets"
environment = Compass::AppIntegration::Rails.env
if environment == 'production'
  css_dir = "tmp/stylesheets"
else
  css_dir = "public/stylesheets"
end

