require 'httparty'
require 'json'
require_relative 'route'

# Sends requests to external service to get route details
class RouteBuilder
  def initialize(from_lat:, from_long:, to_lat:, to_long:)
    @query = { from_lat: from_lat, from_long: from_long,
               to_lat: to_lat, to_long: to_long }
  end

  def build
    response = HTTParty.get(Config.route_builder_endpoint, query: @query)
    body = JSON.parse(response.body)
    Route.new(minutes: body['minutes'].to_i, distance: body['distance'].to_f)
  end
end
