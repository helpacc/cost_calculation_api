require_relative '../lib/cost_calculator'
require_relative '../lib/tariff'
require_relative '../lib/route'

RSpec.describe CostCalculator do
  let(:example_tariff) do
    Tariff.new(request_cost: 50, minute_cost: 10, dist_unit_cost: 3,
               minimal_cost: 100)
  end

  describe '#calculate' do
    it 'calculates cost based on route and tariff' do
      route = Route.new(minutes: 15, distance: 2)
      cost = CostCalculator.new(route, example_tariff).calculate
      expect(cost.cents).to eq(206) # 50 + 10*15 + 3*2
    end

    it "respects tariff's minimal cost" do
      route = Route.new(minutes: 1, distance: 2)
      cost = CostCalculator.new(route, example_tariff).calculate
      expect(cost.cents).to eq(100)
    end
  end
end
