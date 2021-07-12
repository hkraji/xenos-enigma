require_relative "../lib/xenos_enigma/radar"

RSpec.describe XenosEnigma::Radar do
  describe 'when working with default data' do
    subject   { XenosEnigma::Radar.new }
    let(:tau) { XenosEnigma::Xenos::Tau.new }

    it 'collect all known xenos' do
      xenos = subject.instance_variable_get(:@known_xenos)

      expect(xenos).to be_a Array
      expect(xenos).not_to be_empty
    end

    it 'return correct scan ahead data' do
      data = subject.send(:look_ahead_data, 0, 0, tau)
      expected_data = <<~eos
        ----o--o
        --o-o---
        --o-----
        -------o
        ------o-
        -o--o---
        o-------
        --o-----
      eos

      expect(data).to eq expected_data.split(/\n/)
      expect(data.first.size).to eq(tau.ship_width)
      expect(data.size).to eq(tau.ship_height)
    end
  end
end
