class PagesController < ApplicationController
  def home
    @site = Site.new
    @site.domain = Domain.new
    @refferal = Refferal.find(session[:refferal_id]) if session[:refferal_id]
  end
end

