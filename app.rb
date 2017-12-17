require 'sinatra'
require 'sinatra/json'
require_relative 'lib/config'
require_relative 'lib/cost_calculator'
require_relative 'lib/route_builder'
require_relative 'lib/tariff'

set :show_exceptions, false

get '/v1/cost' do
  return abort_on_coords_missing if any_coord_missing?
  tariff = choose_tariff
  return abort_on_invalid_tariff if tariff_set? && !tariff

  cost = CostCalculator.new(build_route, tariff).calculate
  json(cost_in_cents: cost.cents, currency: cost.currency)
end

private

def any_coord_missing?
  %i[from_lat from_long to_lat to_long].detect do |param_name|
    params[param_name].to_s.empty?
  end
end

def abort_on_coords_missing
  status :unprocessable_entity
  json(message: 'from_lat, from_long, to_lat, to_long should be set')
end

def abort_on_invalid_tariff
  status :unprocessable_entity
  json(message: "Tariff #{params['tariff']} doesn't exist")
end

def choose_tariff
  return Tariff.default unless tariff_set?
  Tariff.find(params['tariff'])
end

def build_route
  RouteBuilder.new(
    from_lat: params['from_lat'],
    from_long: params['from_long'],
    to_lat: params['to_lat'],
    to_long: params['to_long']
  ).build
end

def tariff_set?
  !params['tariff'].to_s.empty?
end
