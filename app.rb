require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger !!!'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path

    

    halt erb(:login_form)
  end
end

get '/' do
  erb 'Can you handle a <a href="/secure/place">secret</a>?'
end

get '/login/form' do

  erb :login_form

end

get '/about' do

  erb :about

end

get '/visit' do

  erb :visit

end

get '/contact' do

  erb :contact

end

post '/login/attempt' do
	
	@password = params[:password]
	

	if @password == 'secret'
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
else 
  
	where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
	
	end
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end

post '/visit' do

  @username = params[:user_name]
  @phone = params[:user_phone]
  @date_time = params[:date_time]
  @barber_select = params[:barber_select]
  @color = params[:hair_color]

hh = {:username => 'Введите имя',:phone => 'Введите телефон',:date_time => 'Введите дату и время'}

hh.each do |key,value|
  if params[key] == ''
    @error = hh[key]
    return erb :visit
  end 
  end


  


  f = File.open './public/users.txt', 'a'
  f.write "User: #{@username}, Phone: #{@phone}, Date and time: #{@date_time}. Barber: #{@barber_select}\n"
  f.close
  @complete = "Dear #{@username}, we'll be waiting you near #{@date_time}. Your barber: #{@barber_select}! Your hair'll be #{@color}"
  erb :complete

end

post '/contact' do

  @email = params[:email]
  @comment = params[:comment]



  f = File.open './public/comments.txt', 'a'
  f.write "email: #{@email} comment: #{@comment} \n"
  f.close
  
  @complete = "We heard your coment. Thx!"
  erb :complete

end