require_relative '../lib/cost_calculator'
require_relative '../lib/tariff'
require_relative '../lib/route'

RSpec.describe CostCalculator do
  describe '#calculate' do
    it 'calculates cost based on route and tariff' do
      route = Route.new(minutes: 1, distance: 2)
      tariff = Tariff.new(request_cost: 50, minute_cost: 10, dist_unit_cost: 3)
      cost = CostCalculator.new(route, tariff).calculate
      expect(cost.cents).to eq(66)
    end
  end
end
