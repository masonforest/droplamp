class RefferalsController < ApplicationController 
  def create
    @user = User.find_by_uid(params[:user_id])
    if @user
      @refferal = Refferal.create( {from_user: @user} )
      session[:refferal_id]= @refferal.id
      redirect_to root_path
    else
      render text: "no such refferal code", status: 404
    end
  end
end
