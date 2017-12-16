require 'sinatra'
require 'sinatra/json'

get '/v1/cost' do
  json(cost_in_cents: 10_000, currency: 'RUR')
end
