require 'sinatra' 
require 'pg' 
 
load './local_env.rb' if File.exist?('./local_env.rb') 
enable :sessions 
 
 
db_params = { 
 	host: ENV['dbhost'], 
 	port: ENV['port'], 
 	dbname: ENV['dbname'], 
 	user: ENV['dbuser'], 
 	password: ENV['password']  
 } 
 
 
db = PG::Connection.new(db_params) 
 
 
get '/' do 
	erb :home 
end 
 
 
post '/studentinfo' do 
 	firstname = params[:firstname] 
 	lastname = params[:lastname] 
 	email = params[:email] 
 	db.exec("INSERT into students (firstname, lastname, email) VALUES ('#{firstname}', '#{lastname}', '#{email}')") 
 	redirect '/display' 
 end 
 
 
get '/display' do 
 	student_info = [] 
 	studentlist = db.exec("SELECT * FROM students") 
 	index = 0 
 	studentlist.each do |student| 
		student_id = student['id'] 
 		student_firstname = student['firstname'] 
 		student_lastname = student['lastname'] 
 		student_email = student['email'] 
 		student_info.push(studentlist[index]) 
 		index = index + 1 
 	end 
 	 
 	session[:student_info] = student_info 
 	erb :display, locals: {student_info: student_info} 
end 
