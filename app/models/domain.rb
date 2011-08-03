class Domain < ActiveRecord::Base
  TLDS=["kissr.co","com","org","net","info"]
  validates_uniqueness_of :domain, :scope => :tld
  def to_s
    "#{self.domain}.#{self.tld}"
  end
  def url
    "http://#{self}"
  end
end
