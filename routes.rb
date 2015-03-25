require 'sinatra'
require 'date'
configure :development do
  set :bind, '0.0.0.0'
  set :port, 3000
end



get '/' do
  
  @start_hour = 8
  @day_length = 10
  erb :index
end

get '/messages' do
  f = File.open("db.xml")
  a = f.read
  f.close
  b = a.split("#")
  c = []
  b.each {|s| c << Nokogiri::XML(s) }
  @document = c.reverse
  erb :view
end

post '/dropxml' do
  content_type :xml
  @value=request.body.string
  log.info("XML: " + @value)
  #@value.read { |s| log.info(s) }
  #File.open('db.txt', 'w') { |file| file.write(@value) }
  File.open('db.xml', 'a') do |f|
    f << @value + "#"
    f.close
  end
end



