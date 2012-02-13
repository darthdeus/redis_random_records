require 'rubygems'
require 'bundler'
Bundler.require :default
require 'sinatra/reloader'


if ENV['REDISTOGO_URL']
  Ohm.connect(url: ENV["REDISTOGO_URL"])
  # $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  Ohm.connect
  # $redis = Redis.new
end

class Loan < Ohm::Model
  %w{name description status funded_amount basket_amount image activity sector use location partner_id posted_date planned_expiration_date loan_amount borrower_count}.each do |attr|
    attribute attr
  end
  index :name
end


class RandomRecords < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @loans = Loan.all.to_a.sample(10)
    slim :index
  end

  get '/fetch' do
    require 'open-uri'
    json = open('http://api.kivaws.org/v1/loans/newest.json').read

    @json = MultiJson.decode(json)

    @json['loans'].each do |loan|
      Loan.create loan
    end

    redirect '/?reloaded'
  end

end

use RandomRecords
