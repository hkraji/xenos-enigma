require_relative 'radar'
require 'byebug'

module XenosEnigma
  class Runner

    def self.start
      radar = XenosEnigma::Radar.new
      radar.scan
      radar.echo
    end

  end
end