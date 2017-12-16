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
    cents = (@tariff.request_cost + dist_cost + time_cost).to_i
    Money.new(cents, @tariff.currency)
  end
end
