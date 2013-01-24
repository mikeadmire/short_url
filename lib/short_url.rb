#!/usr/bin/env ruby

require 'redis'
require 'yaml'

class ShortURL

  attr_accessor :adminurl
 
  def self.autocreate(url)
    set = self.new
    key = set.generate_key
    set.create(key, url)
  end

  def self.create(key, url)
    set = self.new
    message = ""
    if set.key_in_use(key)
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
    @base_url = config['baseurl']
    @adminurl = config['adminurl']
    @redis = Redis.new(:db => config['dbnum'])
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
    "#{@base_url}#{key}"
  end

  def generate_key
    key = random_char
    if key_in_use(key)
      generate_key
    else
      return key
    end
  end

  def key_in_use(key)
    !(@redis.get(key).nil?)
  end

  def random_char
    o = [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
    (0...3).map{ o[rand(o.length)] }.join
  end

end


if __FILE__ == $0

  p ShortURL.new.list

end


