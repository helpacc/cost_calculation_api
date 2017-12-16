require_relative '../lib/tariff'

RSpec.describe Tariff do
  after { Tariff.clear_loaded }

  describe '.load' do
    it 'loads tariffs from config/tariffs.yml file' do
      expect(Tariff.loaded).to be_empty
      Tariff.load
      expect(Tariff.loaded).not_to be_empty
      expect(Tariff.loaded).to all(be_a(Tariff))
    end

    # shallow check
    it 'properly sets attributes' do
      path = File.join(__dir__, '..', 'config', 'tariffs.yml')
      expected_value = YAML.load_file(path)['tariffs'][0][:request_cost]
      Tariff.load
      expect(Tariff.loaded.first.request_cost).to eq expected_value
    end
  end
end
