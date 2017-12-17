# value object for route details
class Route
  attr_reader :minutes, :distance

  def initialize(minutes:, distance:)
    @minutes = minutes
    @distance = distance
  end
end
