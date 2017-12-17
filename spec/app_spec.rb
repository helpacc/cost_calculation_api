require 'rack/test'
require_relative '../app'

RSpec.describe 'Cost Calculation API' do
  include Rack::Test::Methods
  before(:all) { Tariff.load }
  after(:all) { Tariff.clear_loaded }

  describe 'GET /v1/cost' do
    def ask_api_for_cost(query)
      get('/v1/cost', query)
    end

    def coord_params(except: nil)
      default = { from_lat: '60', from_long: '60', to_lat: '60', to_long: '60' }
      default.reject { |key, value| except == key }
    end

    it 'responds successfully with JSON object' do
      ask_api_for_cost(coord_params)
      expect(last_response.status).to eq 200
      expect(last_response.header['Content-Type']).to eq 'application/json'
      expect(json_body).to be_a(Hash)
    end

    it 'returns "cost_in_cents" and "currency" attributes' do
      ask_api_for_cost(coord_params)
      expect(json_body['cost_in_cents']).to be_an(Integer)
      expect(json_body['currency']).to be_a(String)
    end

    it 'requires all coordinates' do
      %i[from_lat from_long to_lat to_long].each do |param_name|
        ask_api_for_cost(coord_params(except: param_name))
        expect(last_response.status).to eq 422
      end
    end

    it 'allows to pass "tariff" attribute' do
      params = coord_params.merge(tariff: Tariff.default.id)
      get('/v1/cost', params)
      expect(last_response.status).to eq 200

      params = coord_params.merge(tariff: 'non_existing')
      get('/v1/cost', params)
      expect(last_response.status).to eq 422
    end
  end

  # move helper methods below to reduce mental load on reading the file
  def app
    Sinatra::Application
  end

  # don't memoize value to support multiple requests per example
  def json_body
    JSON.parse(last_response.body)
  end
end
