require 'sinatra'
require 'redis'
require 'json'

def get_connection
  if ENV.has_key?("REDISCLOUD_URL")
    Redis.new(url: ENV["REDISCLOUD_URL"])
  else
    Redis.new
  end
end

def find_articles
  redis = get_connection
  serialized_articles = redis.lrange("slacker:articles", 0, -1)

  @articles = []

  serialized_articles.each do |article|
    @articles << JSON.parse(article, symbolize_names: true)
  end
  redis.quit
  @articles
end

def save_article(url, title, description)
  article = { url: url, title: title, description: description }

  redis = get_connection
  redis.rpush("slacker:articles", article.to_json)
end

get '/' do
  find_articles
  erb :articles
end

get '/submit' do
  erb :submit
end

post '/submit' do
  title = params['title']
  url = params['url']
  des = params['description']

  save_article(url, title, des)

  redirect '/'
end
