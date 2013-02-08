require 'sinatra'
require File.expand_path('lib/short_url')

class Server

  # Setup basic auth helpers
  helpers do
    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials &&
        @auth.credentials == ShortURL.new.auth_credentials
    end
  end


  get '/' do
    redirect ShortURL.new.defaulturl
  end

  get "/#{ShortURL.new.adminurl}" do
    protected!
    @list = ShortURL.new.list
    @baseurl = ShortURL.new.baseurl
    erb :admin
  end

  post "/#{ShortURL.new.adminurl}" do
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

    if (url)
      redirect url
    else
      File.read(File.join('public', '404.html'))
    end

  end

end
