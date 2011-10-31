require 'resolv'
class Domain < ActiveRecord::Base
  TLDS=["kissr.co","com","org","net","info"]
  validates_uniqueness_of :domain, :scope => :tld
  def to_s
    "#{self.domain}.#{self.tld}"
  end
  def self.available(domain,tld)
    begin
      not tld.include?(".") and NameDotCom::API.new.check_domain( :keyword =>domain.to_s, :tlds => [tld],:services=>["availablity"] )['domains']["#{domain}.#{tld}"].avail
    rescue
      false
    end
  end
  def self.status(domain,tld)
    return :available  if tld=="kissr.co" and !Site.where(:hostname=>"#{domain}.#{tld}").exists?
    if available(domain,tld) 
    #   return ("75.101.163.44" "75.101.145.87" "174.129.212.2").include?(Resolv.getaddress("www.#{domain}.#{tld}")) ? :pointed : :taken
      :available
    else
     :taken 
    end
    end
    def url
      "http://#{self}"
    end
end
