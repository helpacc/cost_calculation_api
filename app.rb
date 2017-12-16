require 'sinatra'
require 'sinatra/json'
require_relative 'lib/cost_calculator'
require_relative 'lib/route'
require_relative 'lib/tariff'

get '/v1/cost' do
  return abort_on_lat_long_missing if lat_or_long_missing?
  tariff = choose_tariff
  return abort_on_invalid_tariff if tariff_set? && !tariff

  route = Route.new(minutes: 15, distance: 5.0)
  cost = CostCalculator.new(route, tariff).calculate
  json(cost_in_cents: cost.cents, currency: cost.currency)
end

private

def lat_or_long_missing?
  params['lat'].to_s.empty? || params['long'].to_s.empty?
end

def abort_on_lat_long_missing
  status :unprocessable_entity
  json(message: '"lat" and "long" params should be present')
end

def abort_on_invalid_tariff
  status :unprocessable_entity
  json(message: "Tariff #{params['tariff']} doesn't exist")
end

def choose_tariff
  return Tariff.default unless tariff_set?
  Tariff.find(params['tariff'])
end

def tariff_set?
  !params['tariff'].to_s.empty?
end
