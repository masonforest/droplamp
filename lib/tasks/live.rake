require 'open-uri'
namespace :sites do
  desc "Show a list of live sites hosted on kissr"
  task :live => :environment do
    Site.all.each do |site|
      begin
        open('http://'+site.hostname) if not site.hostname.blank?
        puts site.hostname
      rescue
      end
    end
  end
end

