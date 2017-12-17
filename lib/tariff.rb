require 'yaml'

# Value object for trip tariffs. All costs are in cents.
# Also contains fetching available tariffs logic.
class Tariff
  attr_reader :currency,
              :dist_unit_cost, # kilometer or mile
              :id, # symbolic name
              :request_cost,
              :minute_cost,
              :minimal_cost

  # WARNING: all costs are in cents
  def initialize(attrs)
    @request_cost = attrs.fetch(:request_cost)
    @minute_cost = attrs.fetch(:minute_cost)
    @dist_unit_cost = attrs.fetch(:dist_unit_cost)
    @minimal_cost = attrs.fetch(:minimal_cost)
    @currency = attrs[:currency] || 'RUB'
    @id = attrs[:id]
  end

  class << self
    def load
      @loaded ||= config['tariffs'].map { |attrs| new(attrs) }
    end

    def clear_loaded
      @loaded = nil
    end

    def loaded
      @loaded || []
    end

    def default
      @default ||= find(config['default'])
    end

    def find(id)
      loaded.find { |candidate| candidate.id == id }
    end

    private

    def config
      path = File.join(__dir__, '..', 'config', 'tariffs.yml')
      @config ||= YAML.load_file(path)
    end
  end
end
