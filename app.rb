require 'rubygems'
require 'bundler'
Bundler.require :default
require 'sinatra/reloader'
require 'json'

if ENV['REDISTOGO_URL']
  Ohm.connect(url: ENV["REDISTOGO_URL"])
  # $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  Ohm.connect
  # $redis = Redis.new
end

$:.unshift File.dirname(__FILE__)
require 'loan'


class RandomRecords < Sinatra::Base

  FEED_URL = 'http://api.kivaws.org/v1/loans/newest.json'

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    if params[:search]
      @loans = Loan.all.select do |loan|
        # we search across all defined attributes ...
        # this can be easily substituted for something like %w{name status} to search only on those
        Loan::ATTRIBUTES.inject(false) do |res, kw|
          res || loan.send(kw).downcase[params[:search].downcase]
        end
      end
    else
      @loans = Loan.all.to_a.sample(10)
    end
    slim :index
  end

  get '/random.json' do
    Loan.all.to_a.sample(10).map(&:to_hash).to_json
  end

  get '/fetch' do
    require 'open-uri'
    json = open(FEED_URL).read

    @json = MultiJson.decode(json)
    @json['loans'].each do |loan|
      Loan.create loan
    end

    redirect '/?reloaded=1'
  end

end

use RandomRecords
