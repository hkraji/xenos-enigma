require_relative '../lib/xenos_enigma/radar'

RSpec.describe XenosEnigma::Radar do
  describe 'when working with default data' do
    subject   { XenosEnigma::Radar.new }
    let(:tau) { XenosEnigma::Xenos::Tau.new }

    it 'collect all known xenos' do
      xenos = subject.instance_variable_get(:@known_xenos)

      expect(xenos).to be_a Array
      expect(xenos).not_to be_empty
    end

    it 'make sure that each xenos is analyzed' do
      expect_any_instance_of(XenosEnigma::Xenos::Tau).to receive(:analyze?).at_least(:once)
      expect_any_instance_of(XenosEnigma::Xenos::Aeldari).to receive(:analyze?).at_least(:once)

      subject.scan
    end

    context 'when specific sample data is provided' do
      before(:each) do
        @expected_data = <<~EOS
          ----o--o
          --o-o---
          --o-----
          -------o
          ------o-
          -o--o---
          o-------
          --o-----
        EOS
      end

      it 'returns correct scan ahead data' do
        data = subject.send(:look_ahead_data, 0, 0, tau)

        expect(data).to eq @expected_data.split(/\n/)
        expect(data.first.size).to eq(tau.ship_width)
        expect(data.size).to eq(tau.ship_height)
      end

      it 'returns correct data partial' do
        data = subject.send(:scan_row_partial, @expected_data, 0, 5)
        expect(data).to eq '----o'
      end
    end
  end
end
