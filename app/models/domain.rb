class Domain < ActiveRecord::Base
  TLDS=["kissr.co","com","org","net","info"]
  validates_uniqueness_of :domain, :scope => :tld
  def to_s
    "#{self.domain}.#{self.tld}"
  end
  def self.status(domain,tld)
   if Domain.where(:domain=>domain,:tld=>tld).exists? or
     (
       not tld.include?(".") and
       not NameDotCom::API.new.check_domain( :keyword =>domain, :tlds => [tld],:services=>["availablity"] ).domains["#{domain}.#{tld}"].avail
      )
     {:status => :taken}
   else 
     {:status => :available}
    end
   end
  def url
    "http://#{self}"
  end
end
