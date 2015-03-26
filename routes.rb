require 'sinatra'
require 'date'
require 'firebase'

configure :development do
  set :server, 'webrick'
  set :bind, '0.0.0.0'
  set :port, 3000
  
end

  $base_uri = 'https://timelog.firebaseio.com/'
  $firebase = Firebase::Client.new($base_uri)


#starts at last monday
get '/' do
  base_uri = 'https://timelog.firebaseio.com/'
  firebase = Firebase::Client.new(base_uri)
  
  today = Date.today
  puts "GETTING ROOT! on #{today}"
  
  until today.monday? do
    today-=1
  end
  
  @start_date = today
  @start_hour = 8
  @day_length = 11
  @data_arr = {}
  days = 6

  days.times do 
    @data_arr[today.to_s] = firebase.get(today.to_s).body if firebase.get(today.to_s).body != nil
    today += 1
  end

  #@data_arr = {"2015-03-24"=>{"8"=>"asdfasdf", "9"=>"asdfasdf", "10"=>"asdfasdf"}, "2015-03-25"=>{"8"=>"test test", "9"=>"test test", "10"=>"test test"}, "2015-03-26"=>{"1"=>"1123123123", "8"=>"Testing worklog", "9"=>"1123123123", "10"=>"4444", "11"=>"1123123123", "12"=>"working with a really long string of text here, we'lls ee how it does"}}
  print @data_arr

  erb :index
end


# get '/date/:date' do
#   #d = "02022014"
#   d = params[:date]
#   @start_date = Date.strptime(d,"%d%m%Y")
#   puts @start_date
#   @start_hour = 8
#   @day_length = 10
#   erb :index
# end

post '/save/:date/:hours/:msg' do
  
  msg = params[:msg]
  date = params[:date]
  hours = []
  hours = params[:hours].split("&&&")
  
  firebase = Firebase::Client.new($base_uri+"/"+date)
  
  hours.each do |hour|
      if msg == "clear!"
        response = firebase.delete(hour)  
      else
        response = firebase.set(hour, msg)
      end
  end
  
  return response.status.to_s
  
end

get '/save/:date/:hours/:msg' do
  
  msg = params[:msg]
  date = params[:date]
  hours = []
  hours = params[:hours].split("&&&")
  
  firebase = Firebase::Client.new($base_uri+"/"+date)
  
  hours.each do |hour|
    response = firebase.set(hour, msg)
  end
  
  redirect_to redirect '/'
  
end



