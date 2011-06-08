class ContactsController  < ApplicationController
def create
Mailer.contact(params).deliver

redirect_to '/'
end
end
