require_relative '../lib/xenos_enigma/hit_collector'
require_relative '../lib/xenos_enigma/xenos/aeldari'

RSpec.describe XenosEnigma::HitCollector do
  describe 'instance methods' do
    subject       { XenosEnigma::HitCollector.new }
    let(:aeldari) { XenosEnigma::Xenos::Aeldari.new }

    before(:each) do
      @hit = XenosEnigma::Hit.new(aeldari)
      subject.push(@hit, 0, 0)
    end

    it 'should correctly process a new hit and each coordinate' do
      (0..aeldari.ship_width - 1).each do |position_x|
        (0..aeldari.ship_height - 1).each do |position_y|
          expect(subject.already_detected?(position_x, position_y)).to be true
        end
      end
    end

    it 'should correctly process a new hit and mark each ship segment' do
      scanned_data = []
      (0..aeldari.ship_width - 1).each do |position_x|
        (0..aeldari.ship_height - 1).each do |position_y|
          scanned_data << subject.detection_data(position_x, position_y)
        end
      end

      ship_signiture = @hit.xeno_instance.xeno_signature.collect do |row|
        row.split(//)
      end.flatten.sort

      expect(ship_signiture).to eq scanned_data.sort
    end
  end
end
