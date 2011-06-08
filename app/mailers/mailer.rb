class Mailer < ActionMailer::Base
  default :from => "mason@stirltech.com"
  def contact(params)
    @params = params
    mail(:to => params[:recipient],
         :subject => params[:subject])
  end
  
end
