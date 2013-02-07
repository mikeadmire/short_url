# ShortUrl

A simple url shortening and redirect service written in Ruby using
Sinatra and Redis. The only landing pages are a 404 page available
in /public and an admin view to create shortened URLs. Even the home
page redirects.

Edit the config.yml file to configure the app.


### config/config.yml

    # baseurl is the public url of the app.
    baseurl: http://example.com/

    # defaulturl is where to redirect users that go directly to the baseurl.
    defaulturl: http://example.com/

    # adminurl is the url with the form to create new shortens urls.
    # example: http://localhost:9393/abcd
    # There is no authentication so this page is open to anyone that finds
    # it. **You should change this**
    adminurl: abcd

    # dbnum is the redis database number. I avoid using 0 since it's the
    # default db. You probably don't need to change this. The default
    # should be fine for most.
    dbnum: 7

    # keysize is the number of characters to be used in your key.
    # keysize 2 *example: http://localhost:9393/Yz
    # keysize 6 *example: http://localhost:9393/YzxX1i
    # Using a small number will limit the number of entries you can have
    # in the db.
    keysize: 3

