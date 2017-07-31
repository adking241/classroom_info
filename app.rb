require 'sinatra'
require 'pg'

load './local_env.rb' if File.exist?('./local_env.rb') #this file houses & hides our env file due to the gitignore file 
enable :sessions #allows us to pass variables from route to route without using urls

db_params = {
	host: ENV['dbhost'],
	port: ENV['port'],
	dbname: ENV['dbname'],
	user: ENV['dbuser'],
	password: ENV['password']
} #set a variable so these connections work for us

db = PG::Connection.new(db_params) #initiates a connection to the database by setting up this variable

get '/' do
	erb :home
end

post '/studentinfo' do #we must have a post here bc we are getting input
	#add new student to the database
	firstname = params[:firstname] 
	lastname = params[:lastname]
	email = params[:email]
	db.exec("INSERT into students (firstname, lastname, email) VALUES ('#{firstname}', '#{lastname}', '#{email}')") #.exec means open a route to our database and to do what we've instructed in paratheses; first set is the column names and the 2nd set is the values from user
	redirect '/display'
end

get '/display' do
	#displays a roster of students in the database
	student_info = [] #creating empty array for student info to get pushed through later
	studentlist = db.exec("SELECT * FROM students ORDER BY id") #set variable equal to everything in student table, the ORDER BY sorts the lists by ID#
	index = 0 #setting counter to zero so we can iterate array later
	studentlist.each do |student| #iterating all the info within the table
		student_id = student['id'] #setting student_id equal to id in the table
		student_firstname = student['firstname'] #pulling out first name
		student_lastname = student['lastname']
		student_email = student['email']
		student_info.push(studentlist[index]) #pushing each record (using counter'index') into the array <<
		index = index + 1 #increasing the counter for each record processed
	end
	
	session[:student_info] = student_info #didn't really need this line
	erb :display, locals: {student_info: student_info} 
end