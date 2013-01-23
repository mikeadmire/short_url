require 'sinatra'
require File.expand_path('lib/short_url')

class Server

  configure do
    set :adminurl, ShortURL.new.adminurl
  end


  get '/' do
    File.read(File.join('public', 'index.html'))
  end

  get '/:key' do
    url = ShortURL.lookup(params[:key])

    if (params[:key] == settings.adminurl)
      erb :admin
    elsif (url)
      redirect url
    else
      File.read(File.join('public', '404.html'))
    end

  end

end
