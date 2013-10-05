require 'rubygems'
require 'sinatra'
require 'webrick'
require 'webrick/https'
require 'openssl'
require 'erb'
require 'recaptcha'
require 'net/http'



Recaptcha.configure do |config|
  config.public_key  = 'public_key'
  config.private_key = 'private_key'
  config.use_ssl_by_default
end


Redirecter_path = 'path_to_redirecter_folder'
Url_files = 'urls/'
Alphabet_cur = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "a", "s", "d", "f", "g", "h", "j", "k", "l", "z", "x", "c", "v", "b", "n", "m", "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

$max_len_random_string = 6


CERT_PATH = 'path_to_redirecter_folder/certs/'

webrick_options = {
        :Port               => 443,
       # :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
        :debugger           => false,
        :DocumentRoot       => "path_to_redirecter_folder",
        :SSLEnable          => true,
        :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
        :SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "server.crt")).read),
        :SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(CERT_PATH, "server.key")).read),
        :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ]
}

class MyServer  < Sinatra::Base

include Recaptcha::ClientHelper
include Recaptcha::Verify

get '/add' do

 erb :add_link
end

post '/add' do

 link = "#{params[:url_to_add]}"
 login = "#{params[:login]}"
 password = "#{params[:password]}"
 chalenge =  "#{params[:challenge]}"


 if verify_recaptcha then

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
        break if (!(FileTest::exists?(path_to_new_file)))
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


get '/*' do
  redirect "http://your_site/err"
end

post '/*' do
  redirect "http://your_site/err"
end

put '/*' do
  redirect "http://your_site/err"
end

patch '/*' do
  redirect "http://your_site/err"
end

delete '/*' do
  redirect "http://your_site/err"
end

options '/*' do
  redirect "http://your_site/err"
end

      
end

Rack::Handler::WEBrick.run MyServer, webrick_options
