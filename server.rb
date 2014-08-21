require 'sinatra'
require 'csv'

def init
  @articles = []

  CSV.foreach('public/articles.csv', headers: true, :header_converters => :symbol) do |row|
    @articles << row.to_hash
  end
end

get '/' do
  init
  erb :articles
end

get '/submit' do
  init
  erb :submit
end

post '/submit' do
  title = params['title']
  url = params['url']
  des = params['description']

  File.open('public/articles.csv', 'a') do |article|
    article.puts("#{title},#{url},#{des}")
  end

  redirect '/'
end
