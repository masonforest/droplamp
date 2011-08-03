class DomainsController < ApplicationController
#caches_page :show

  def new
    @domain = Domain.new
  end
  def show
    File.open('/tmp/debug', 'w') {|f| f.write('Host:'+request.host) }
    @output  = Domain.find_by_domain(request.host).render(params[:path])   
   render :text => @output[:content], :content_type => @output[:content_type]    
  end
  def create
    params[:domain][:user_id]=session[:user]
    params[:domain][:path]='/'+params[:domain][:path]
    if not params[:new].blank?
      begin
      Domain.create_domain_folder(params[:domain][:path],session[:dropbox])
      rescue Dropbox::FileExistsError
        flash[:error]="The folder "+params[:domain][:path]+" already exists in your dropbox"
        @domain=Domain.new
           return redirect_to '/dropbox/connect' unless session[:dropbox]
    dropbox = Dropbox::Session.deserialize(session[:dropbox])
    return redirect_to '/dropbox/connect' unless dropbox.authorized?
   
     dropbox.mode = :dropbox  
     @files = dropbox.list ""
         return render '/dropbox/show' 
      end
    end 
    @domain = Domain.new(params[:domain])
    if @domain.save
      redirect_to '/dropbox'
    end
  end
  def index
    return redirect_to '/dropbox/connect' unless session[:dropbox]
    dropbox = Dropbox::Session.deserialize(session[:dropbox])
    return redirect_to '/dropbox/connect' unless dropbox.authorized? 
    dropbox.mode = :dropbox 
    @files = dropbox.list ""
  end
 def destroy
    @domain = Domain.find(params[:id])
    flash[:message]="Deleted "+@domain.subdomain+"."+@domain.domain 
    @domain.destroy
    redirect_to "/dropbox"
 end
end
