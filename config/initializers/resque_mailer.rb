class AsyncMailer < ActionMailer::Base
  include Resque::Mailer
  default :from => "website@kissr.co"
end
Resque::Mailer.excluded_environments = [:test, :cucumber]
