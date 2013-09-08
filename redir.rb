require 'rubygems'
require 'sinatra'
require 'erb'
require 'rack/recaptcha'
set :run, true
set :port, 80
set :bind, '0.0.0.0'

use Rack::Recaptcha, :public_key => 'key', :private_key => 'key'
helpers Rack::Recaptcha::Helpers

$max_len_random_string = 6
Redirecter_path = 'path_to_redirecter_folder'
Url_files = 'urls/'
Alphabet_cur = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "a", "s", "d", "f", "g", "h", "j", "k", "l", "z", "x", "c", "v", "b", "n", "m", "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

get '/' do
  'Hello!'
end

get '/add' do

 erb :add_link
end

post '/add' do

 link = "#{params[:url_to_add]}"
 login = "#{params[:login]}"
 password = "#{params[:password]}"
 chalenge =  "#{params[:challenge]}"
 
 if recaptcha_valid? then

   login_pass_path = ''
   login_pass_path = Redirecter_path + 'passwd'
   login_pass_file = File.new(login_pass_path,"r")
 
   link_created = 0
   random_name = 0
   path_to_new_file = ''

   login_pass_file.each do |line|
    line.chomp!
    lp = line.split
    if lp[0] == login and lp[1] == password then
      login_pass_file.close
    
      loop do
        random_name = ''
        path_to_new_file = ''
        len_random_string = rand($max_len_random_string)+1
        i = 0
        while i < len_random_string do
          random_name = random_name + Alphabet_cur[rand(Alphabet_cur.size)]
          i = i+1
        end
        path_to_new_file = Redirecter_path + Url_files + random_name
        break if !(FileTest::exists?(path_to_new_file))
      end
      new_url_file = File.new(path_to_new_file,"w")
      new_url_file.puts(link)
      new_url_file.close
      @new_file = random_name
      link_created = 1
      break
    end
   end
   if link_created == 0 then
     erb :error_login
   else
     erb :new_link
   end

 else
    "failed recapcha!"
 end

end

get '/err' do
  'Url in database not found :-( '
end

get '/:file_s' do
  fia = params[:file_s]
  file_path = ''
  file_path = Redirecter_path + Url_files + fia.to_s
 
  if FileTest::exists?(file_path) then
    r_file = File.new(file_path,"r")
    link_url = r_file.gets
    link_url.chomp!
    r_file.close
    redirect link_url
  
  else
    redirect "/err"

  end

end

get '/*' do
  redirect "/err"
end

post '/*' do
  redirect "/err"
end

put '/*' do
  redirect "/err"
end

patch '/*' do
  redirect "/err"
end

delete '/*' do
  redirect "/err"
end

options '/*' do
  redirect "/err"
end
