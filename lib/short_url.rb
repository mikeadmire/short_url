#!/usr/bin/env ruby

require 'redis'
require 'yaml'

class ShortURL

  attr_reader :adminurl, :defaulturl, :auth_credentials, :baseurl
 
  def self.autocreate(url)
    set = self.new
    key = set.generate_key
    set.create(key, url)
  end

  def self.create(key, url)
    set = self.new
    message = ""
    if set.key_in_use?(key)
      message = "Key is already in use"
    else
      message = set.create(key, url)
    end
    message
  end

  def self.lookup(key)
    set = self.new
    set.lookup(key)
  end



  def initialize
    config = YAML.load_file(File.join('config', 'config.yml'))
    @baseurl = config['baseurl']
    @defaulturl = config['defaulturl']
    @adminurl = config['adminurl']
    @keysize = config['keysize']
    @redis = Redis.new(:db => config['dbnum'])
    @auth_credentials = [config['username'], config['password']]
  end

  def lookup(key)
    @redis.get(key)
  end

  def list
    keys = @redis.keys('*')
    list = Hash.new
    keys.each do |key|
      list[key] = @redis.get(key)
    end
    list.sort_by {|key,url| key}
  end
 
  def create(key, url)
    @redis.set(key, url)
    "#{@baseurl}#{key}"
  end

  def generate_key
    key = random_chars
    if(key == @adminurl || key_in_use?(key))
      generate_key
    end
    key
  end

  def key_in_use?(key)
    !(@redis.get(key).nil?)
  end

  def random_chars
    o = [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
    (0...@keysize).map{ o[rand(o.length)] }.join
  end

end


if __FILE__ == $0

  p ShortURL.new.list

end

