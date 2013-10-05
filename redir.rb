require 'rubygems'
require 'sinatra'
set :run, true
set :port, 80
set :bind, '0.0.0.0'


Redirecter_path = 'path_to_redirecter_folder'
Url_files = 'urls/'

get '/' do
  'Hello!'
end

get '/add' do
    redirect "https://your_site/add"
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
