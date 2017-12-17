require 'money'

# Calculate route cost based on distance, time and tariff
class CostCalculator
  def initialize(route, tariff)
    @route = route
    @tariff = tariff
  end

  def calculate
    dist_cost = @route.distance * @tariff.dist_unit_cost
    time_cost = @route.minutes * @tariff.minute_cost
    total = (@tariff.request_cost + dist_cost + time_cost).to_i
    final_cost = [total, @tariff.minimal_cost].max
    Money.new(final_cost, @tariff.currency)
  end
end
