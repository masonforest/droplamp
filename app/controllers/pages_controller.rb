class PagesController < ApplicationController
  def home
  end
  def show
    render params[:id]
  end
end

