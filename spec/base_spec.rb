require_relative '../lib/xenos_enigma/xenos/tau'
require_relative 'helpers/randomize'

RSpec.configure do |config|
  config.include Randomize
end

RSpec.describe XenosEnigma::Xenos::Base do
  describe 'instance methods' do
    let(:tau)     { XenosEnigma::Xenos::Tau.new }
    let(:data)    { tau.xeno_signature }

    it 'should not allow class to be instanced' do
      expect { XenosEnigma::Xenos::Base.new }.to raise_exception(RuntimeError, 'This is an abstract class')
    end

    it 'should match pattern as a possible match' do
      expect(tau.send(:possible_match?, '---oo---', '---o-o--')).to be true
      expect(tau.send(:possible_match?, '---oo---', '--o-o---')).to be true
    end

    it 'should not match pattern as a possible match' do
      expect(tau.send(:possible_match?, '---oo---', '-----o--')).to be false
      expect(tau.send(:possible_match?, '---oo---', '--o-----')).to be false
    end

    it 'should analyze data correctly and return exact hit' do
      rdata = randomize_data(data)
      result = tau.analyze?(rdata[0], rdata)

      expect(result).to be_a XenosEnigma::Hit
      expect(result.xeno_y_start).to eq 0
    end

    it 'should analyze data correctly and return partial hit from top of the ship' do
      rdata = randomize_data(data.take(5))
      result = tau.analyze?(rdata[0], rdata)

      expect(result).to be_a XenosEnigma::Hit
      expect(result.xeno_y_start).to eq 0
    end

    it 'should analyze data correctly and return partial hit from bottom of the ship' do
      ship_segments = 4

      partial_data = data.dup[ship_segments..-1]
      rdata = randomize_data(partial_data)
      result = tau.analyze?(rdata[0], rdata)

      expect(result).to be_a XenosEnigma::Hit
      expect(result.xeno_y_start).to eq ship_segments
    end

    it 'should analyze data and not return a hit' do
      rdata = randomize_data(['--------'] * 8)
      result = tau.analyze?(rdata[0], rdata)

      expect(result).to be nil
    end
  end
end