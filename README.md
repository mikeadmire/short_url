# ShortUrl

A simple url shortening and redirect service written in Ruby using
Sinatra and Redis. The only landing pages are a 404 page available
in /public and an admin view to create shortened URLs. Even the home
page redirects.

## Installation

It's a Rack app. You need a Rack application server like Passenger
or Unicorn or a service like Heroku in order to run it. You can
find more info at <http://rack.rubyforge.org/doc/>

1. git clone git://github.com/mikeadmire/short_url.git
2. cd short_url
3. bundle install
4. mv config/config.yml_example config/config.yml
5. edit config/config.yml
6. deploy

