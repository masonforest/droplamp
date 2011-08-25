class DomainsController < ApplicationController
  def status
    render :json => Domain.status(params[:domain],params[:tld])
  end
end
