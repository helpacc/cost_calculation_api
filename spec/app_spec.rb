require 'rack/test'
require_relative '../app'

RSpec.describe 'Cost Calculation API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'responds with JSON successfully' do
    get '/'
    expect(last_response.status).to eq 200
    expect(last_response.header['Content-Type']).to eq 'application/json'
  end
end
