# Simplify access to config values
module Config
  def self.route_builder_endpoint
    ENV['ROUTE_BUILDER_ENDPOINT']
  end
end
