class PagesController < ApplicationController
  def home
    @site = Site.new
    @site.domain = Domain.new
  end
end

