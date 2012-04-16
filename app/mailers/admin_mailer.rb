class AdminMailer < AsyncMailer
  def signup(user_id)
    @user = User.find(user_id)
    mail(:to => "mason@kissr.co", :subject => "#{@user.name} has signed up for KISSr")
  end
end

