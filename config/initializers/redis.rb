require 'redis'
require 'redis/objects'
Redis::Objects.redis = Redis.new(:host => '127.0.0.1', :port => 6379)
