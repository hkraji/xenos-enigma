require_relative "../lib/xenos_enigma/radar"

RSpec.describe "XenosEnigma::Radar" do
  describe "when working with default data" do
    radar = XenosEnigma::Radar.new

    it "returns correct scan dimensions" do
      xeno = XenosEnigma::Xenos::Tao.new

      data = radar.send(:look_ahead_data, 12, 22, xeno)

      expect(data.first.size).to eq(xeno.ship_width)
      expect(data.size).to eq(xeno.ship_height)
    end
  end
end
