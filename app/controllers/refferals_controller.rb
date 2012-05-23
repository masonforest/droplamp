class RefferalsController < ApplicationController 
  def create
    @user = User.find(params[:user_id])
    if @user
      if @user == current_user
        return render text: "Sorry #{current_user.first_name} you cannot reffer yourself", status: 500
      end
      session[:reffered_by_id]= @user.id
      redirect_to root_path
    else
      render text: "no such refferal code", status: 404
    end
  end
end
