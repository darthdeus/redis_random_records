require 'rubygems'
require 'rspec'
require 'redis'
require 'redis-namespace'
require 'ohm'
require 'pry'

class Parser
  def dump(instance, data)
    data["loans"]
  end
end

class Loan < Ohm::Model
  %w{name description status funded_amount basket_amount image activity sector use location partner_id posted_date planned_expiration_date loan_amount borrower_count}.each do |attr|
    attribute attr
  end
end

describe Parser do
  before do
    @data = {"paging"=>{"page"=>1, "total"=>2632, "page_size"=>20, "pages"=>132},
             "loans"=>
                 [{"id"=>389754,
                  "name"=>"Vilma Pacheco Anillo",
                  "description"=>{"languages"=>["es", "en"]},
                   "status"=>"fundraising",
                   "funded_amount"=>0,
                   "basket_amount"=>0,
                   "image"=>{"id"=>1001593, "template_id"=>1},
                   "activity"=>"Pigs",
                   "sector"=>"Agriculture",
                   "use"=>"to buy pigs in neighboring towns, which offer her a good price, and cheese",
                   "location"=>{"country_code"=>"CO", "country"=>"Colombia", "town"=>"San Jacinto-Bol\u00EDvar",
                                "geo"=>{"level"=>"country", "pairs"=>"4 -72", "type"=>"point"}},
                   "partner_id"=>154, "posted_date"=>"2012-02-12T21:50:03Z",
                   "planned_expiration_date"=>"2012-03-13T21:50:03Z",
                   "loan_amount"=>525,
                   "borrower_count"=>1},

                  {"id"=>389093, "name"=>"Sarmen Aghakhanyan", "description"=>{"languages"=>["en"]},
                   "status"=>"fundraising", "funded_amount"=>0, "basket_amount"=>0,
                   "image"=>{"id"=>1000584, "template_id"=>1}, "activity"=>"Cattle", "sector"=>"Agriculture",
                   "use"=>"to purchase more cows.",
                   "location"=>{"country_code"=>"AM", "country"=>"Armenia", "town"=>"Yelpin village of Vayots Dzor region",
                                "geo"=>{"level"=>"country", "pairs"=>"40 45", "type"=>"point"}},
                   "partner_id"=>169, "posted_date"=>"2012-02-12T20:00:03Z", "planned_expiration_date"=>"2012-03-13T20:00:03Z",
                   "loan_amount"=>1500, "borrower_count"=>1}
                 ]}

    redis = Redis.new
    @redis = Redis::Namespace.new(:random_test, :redis => redis)

    @data['loans'].each do |loan|
      Loan.create loan
    end
  end

  after do
    @redis.keys.each { |k| @redis.del k }
  end

  it "sets data in redis" do
    binding.pry
  end

end