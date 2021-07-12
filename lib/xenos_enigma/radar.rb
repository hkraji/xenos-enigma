require_relative 'default_data'
require_relative 'hit_collector'
Dir[File.expand_path('xenos/*.rb', File.dirname(__FILE__))].each do |file|
  require_relative file
end

module XenosEnigma
  class Radar
    include DefaultData

    def initialize(data = nil)
      @data = (data || SCAN_DATA).split(/\n/)
      @known_xenos = load_all_known_xenos
      @hit_collector = XenosEnigma::HitCollector.new
    end

    def scan
      @data.each_with_index do |scan_row, scan_position_y|
        for scan_position_x in 0..scan_row.length
          next if @hit_collector.already_detected?(scan_position_x, scan_position_y)

          @known_xenos.each do |xeno|
            partial = scan_row_partial(scan_row, scan_position_x, xeno.ship_width)
            hit = xeno.analyze?(partial, look_ahead_data(scan_position_x, scan_position_y, xeno))
            @hit_collector.push(hit, scan_position_x, scan_position_y) if hit
          end
        end
      end
    end

    def echo
      echo_width  = @data.first.size - 1
      echo_height = @data.size - 1
      print "\033[33m"

      for echo_y in 0..echo_height
        for echo_x in 0..echo_width
          hit_data = @hit_collector.detection_data(echo_x, echo_y)
          print hit_data ? hit_data : "-"
        end
        puts
      end
    end


    private

    def look_ahead_data(position_x, position_y, xeno)
      results = []
      scan_to_y = [(position_y + xeno.ship_height), @data.size].min - 1
      for scan_y in position_y..scan_to_y
        partial = scan_row_partial(@data[scan_y], position_x, xeno.ship_width)
        results.push(partial)
      end
      results
    end

    def scan_row_partial(scan_row, position_x, x_offset)
      scan_row[position_x..(position_x + x_offset - 1)]
    end

    def load_all_known_xenos
      xenox_clazzes = XenosEnigma::Xenos.constants.reject { |xc| xc.downcase.eql?(:base) }
      xenox_clazzes.collect { |xc| XenosEnigma::Xenos.const_get(xc).new }
    end

  end
end