require 'sinatra'
require 'pry'
require 'redis'
require 'securerandom'

helpers do
  def redis
    @@redis ||= Redis.new(url: 'redis://redistogo:1285c75b8902111d6a2a07295357f622@grideye.redistogo.com:9487/')
    #  @@redis ||= Redis.new()
  end

end

post '/set' do
  url = params[:url]
  s = SecureRandom.hex(3)
  while redis.get(s)
    s = SecureRandom.hex(3)
  end
  redis.set(s, url)

  request.scheme + "://" + request.host + ":" + request.port.to_s +  "/" + s
end

get '/**' do
  param = params['splat']
  url = redis.get(param[1])
  redirect url
end
