# value object for route detaild
class Route
  attr_reader :minutes, :distance

  def initialize(minutes:, distance:)
    @minutes = minutes
    @distance = distance
  end
end
