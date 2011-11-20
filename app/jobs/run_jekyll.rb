class RunJekyll
  @queue = :process
  def self.perform(id)
    puts "Generating Site ##{id}"
    db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/kissr')
    require 'active_record'
    require 'uri'

    ActiveRecord::Base.establish_connection(
      :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
    )
    
    @site=Site.find(id)
    @site.sync
    @site.run_jekyll
    @site.upload
    puts "Generated #{@site.hostname}"
  end
end

