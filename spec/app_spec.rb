require 'rack/test'
require_relative '../app'

RSpec.describe 'Cost Calculation API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # don't memoize value to support multiple requests per example
  def json_body
    JSON.parse(last_response.body)
  end

  # arguably it looks clumsy with :query default value inlined in method definition
  def ask_api_for_cost(query: nil)
    get('/v1/cost', query || { lat: '60', long: '60' })
  end

  it 'responds successfully with JSON object' do
    ask_api_for_cost
    expect(last_response.status).to eq 200
    expect(last_response.header['Content-Type']).to eq 'application/json'
    expect(json_body).to be_a(Hash)
  end

  it 'returns "cost_in_cents" and "currency" attributes' do
    ask_api_for_cost
    expect(json_body['cost_in_cents']).to be_an(Integer)
    expect(json_body['currency']).to be_a(String)
  end

  it 'requires "lat" and "long" query parameters' do
    ask_api_for_cost(query: {})
    expect(last_response.status).to eq 422

    ask_api_for_cost(query: { lat: '60' })
    expect(last_response.status).to eq 422

    ask_api_for_cost(query: { long: '60' })
    expect(last_response.status).to eq 422
  end
end
