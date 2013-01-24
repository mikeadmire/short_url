require 'sinatra'
require File.expand_path('lib/short_url')

class Server

  configure do
    set :adminurl, ShortURL.new.adminurl
  end


  get '/' do
    File.read(File.join('public', 'index.html'))
  end

  post "/#{settings.adminurl}" do
    if (!params[:key].empty? && !params[:url].empty?)
      message = ShortURL.create(params[:key], params[:url])
    elsif (!params[:url].empty?)
      message = ShortURL.autocreate(params[:url])
    else
      message = "Error: Unable to create shortened URL"
    end
    message
  end

  get '/:key' do
    url = ShortURL.lookup(params[:key])

    if (params[:key] == settings.adminurl)
      @list = ShortURL.new.list
      erb :admin
    elsif (url)
      redirect url
    else
      File.read(File.join('public', '404.html'))
    end

  end

end
