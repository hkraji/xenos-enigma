module XenosEnigma
  module Xenos
    class Base
      attr_reader :ship_width, :ship_height, :xeno_signature

      SHIP_DETECTION = { tolerance: 2, compound_tolerance: 1.6, min_segments: 3 }.freeze

      def initialize
        raise RuntimeError, 'This is an abstract class' if instance_of?(XenosEnigma::Xenos::Base)

        @xeno_signature = self.class::SIGNATURE.split(/\n/)
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

      private

      def full_scan(xeno_y_position, look_ahead_radar_data)
        compound_match_score = 0
        lines_scanned = 0

        (xeno_y_position..(ship_height - 1)).each do |y_scan|
          break if look_ahead_radar_data[y_scan - xeno_y_position].nil?

          compound_match_score += pattern_difference(@xeno_signature[y_scan], look_ahead_radar_data[y_scan - xeno_y_position])
          lines_scanned += 1
        end

        is_detection_cofirmed = (lines_scanned * SHIP_DETECTION[:compound_tolerance] >= compound_match_score)

        if lines_scanned >= SHIP_DETECTION[:min_segments] && is_detection_cofirmed
          XenosEnigma::Hit.new(self, xeno_y_position)
        end
      end

      def possible_match?(xeno_row, radar_partial)
        pattern_difference(xeno_row, radar_partial) <= SHIP_DETECTION[:tolerance]
      end

      def pattern_difference(data1, data2)
        DidYouMean::Levenshtein.distance(data1, data2)
      end
    end
  end
end
