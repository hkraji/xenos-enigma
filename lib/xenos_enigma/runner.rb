require_relative 'radar'
require 'getoptlong'

module XenosEnigma
  # Runner is responsable for end user interaction via console
  class Runner
    def self.start
      radar_data = nil

      opts = GetoptLong.new(['--help', '-h', GetoptLong::NO_ARGUMENT], ['--path', GetoptLong::OPTIONAL_ARGUMENT])
      opts = Hash[*opts.get_option]

      if opts['--help']
        puts 'Usage: xenos-enigma [--path FILE]'
        puts "--help  \t show help"
        puts "--path FILE \t set path to radar data file, uses default data if no file provided"
        exit(0)
      end

      if (file_provided = opts['--path'])
        unless File.exist?(file_provided)
          warn "File #{file_provided} not found"
          exit(1)
        end

        radar_data = File.read(file_provided)
      end

      radar = XenosEnigma::Radar.new(radar_data)
      radar.scan
      radar.echo
    end
  end
end
