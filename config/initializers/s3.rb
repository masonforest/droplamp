require 'aws/s3'  
AWS::S3::Base.establish_connection!(
    :access_key_id     => ENV['AMAZON_ACCESS_KEY'], 
    :secret_access_key => ENV['AMAZON_SECRET_KEY']
)

