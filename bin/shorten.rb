#!/usr/bin/env ruby
require File.expand_path('../lib/short_url', File.dirname(__FILE__))


class Shorten

  def self.create(key, url)
    ShortURL.create(key, url)
  end

  def self.autocreate(url)
    ShortURL.autocreate(url)
  end

end


if __FILE__ == $0

  if (ARGV.length == 1)
    Shorten.autocreate(ARGV[0])
  elsif (ARGV.length == 2)
    Shorten.create(ARGV[0], ARGV[1])
  else
    puts "\nUsage:\n#{$0} url  (auto generates a key for you)\n"\
         "#{$0} key url  (you assign the key)\n\n"
  end

end


