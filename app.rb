require 'rubygems'
require 'bundler'
Bundler.require :default
require 'sinatra/reloader'


if ENV['REDISTOGO_URL']
  uri = URI.parse(ENV["REDISTOGO_URL"])
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  $redis = Redis.new
end


class RandomRecords < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    require 'open-uri'
    json = open('http://api.kivaws.org/v1/loans/newest.json').read
    @json = MultiJson.decode(json)
    slim :index
  end

end

use RandomRecords
