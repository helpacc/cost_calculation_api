require 'sinatra'
require 'sinatra/json'
require 'pry-byebug'

get '/v1/cost' do
  return abort_on_lat_long_missing if lat_or_long_missing?
  json(cost_in_cents: 10_000, currency: 'RUR')
end

private

def lat_or_long_missing?
  params['lat'].to_s.empty? || params['long'].to_s.empty?
end

def abort_on_lat_long_missing
  status :unprocessable_entity
  json(message: '"lat" and "long" params should be present')
end
