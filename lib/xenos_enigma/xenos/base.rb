module XenosEnigma
  module Xenos
    class Base
      attr_reader :ship_width, :ship_height, :xeno_signature

      SHIP_DETECTION_TOLERANCE = 2
      SHIP_DETECTION_COMPOUND_TOLERENCE = 1.6
      MIN_DETECTION_SHIP_SEGMENTS = 3

      def initialize
        raise "This is a abstract class" if self.class.eql?(XenosEnigma::Xenos::Base) 

        @xeno_signature = self.class::SIGNITURE.split(/\n/)
        @ship_width  = @xeno_signature.first.size
        @ship_height = @xeno_signature.size
      end

      def analyze?(radar_partial, look_ahead_radar_data)
        return if radar_partial.size < ship_width
        hit = nil

        @xeno_signature.each_with_index do |xeno_row, xeno_y_position|
          if possible_match?(xeno_row, radar_partial)
            hit = full_scan(xeno_y_position, look_ahead_radar_data)
            break if hit
          end
        end

        hit
      end

      def full_scan(xeno_y_position, look_ahead_radar_data)
        compound_match_score = 0
        lines_scanned = 0

        for y_scan in xeno_y_position..(ship_height-1)
          break if look_ahead_radar_data[y_scan - xeno_y_position].nil?

          compound_match_score += pattern_difference(@xeno_signature[y_scan], look_ahead_radar_data[y_scan - xeno_y_position])
          lines_scanned += 1
        end

        is_detection_cofirmed = lines_scanned * SHIP_DETECTION_COMPOUND_TOLERENCE >= compound_match_score

        if lines_scanned == ship_height && is_detection_cofirmed
          return XenosEnigma::Hit.new(self)
        end

        if lines_scanned >= MIN_DETECTION_SHIP_SEGMENTS && is_detection_cofirmed
          return XenosEnigma::Hit.new(self, xeno_y_position)
        end
      end

      private

      def possible_match?(xeno_row, radar_partial)
        pattern_difference(xeno_row, radar_partial) <= SHIP_DETECTION_TOLERANCE
      end

      def pattern_difference(data1, data2)
        DidYouMean::Levenshtein.distance(data1, data2)
      end

    end
  end
end