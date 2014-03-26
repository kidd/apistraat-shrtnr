require 'sinatra'
require 'pry'
require 'redis'
require 'securerandom'

helpers do
  def redis
    @@redis ||= Redis.new(url: ENV['REDISTOGO_URL'] || 'redis://localhost:6379')
    #  @@redis ||= Redis.new()
  end

end

post '/set' do
  url = params[:url]
  s = SecureRandom.hex(1)
  while redis.get(s)
    s = SecureRandom.hex(1)
  end
  redis.set(s, url)

  request.scheme + "://" + request.host + ":" + request.port.to_s +  "/" + s
end

get '/**' do
  param = params['splat']
  url = redis.get(param[1])
  redirect url
end
