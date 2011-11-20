Resque.after_fork = Proc.new {
 db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/kissr')
  ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)
 }

Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == "secret"
end

