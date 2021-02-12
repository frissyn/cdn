require 'sinatra'
require 'securerandom'

set :port, 8080
set :bind, '0.0.0.0'
set :exception, false
set :protection, :except => :frame_options

get "/" do
    erb :index
end

get "/files" do
    @files = Dir.entries("public/content")[2..-1]

    erb :files
end

get "/file/:file" do
    send_file File.join("public/content", params['file'])
end

get "/upload" do
    erb :upload
end

post "/upload" do
    @filename = params[:file][:filename]

    token = SecureRandom.hex(8)
    parsed = @filename.split "."

    file = params[:file][:tempfile]

    File.open("./public/content/#{token}.#{parsed[-1]}", 'wb') do |f|
        f.write(file.read)
    end

    redirect "/file/#{token}.#{parsed[-1]}"
end
