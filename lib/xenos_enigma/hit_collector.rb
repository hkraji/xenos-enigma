module XenosEnigma
  class HitCollector

    def initialize
      @hit_matrix_cache = {}
    end

    def detection_data(position_x, position_y)
      get_cache(position_x, position_y)
    end

    def already_detected?(position_x, position_y)
      !get_cache(position_x, position_y).nil?
    end

    def push(xeno_hit, scan_position_x, scan_position_y)
      xeno_hit.radar_x_position = scan_position_x
      xeno_hit.radar_y_position = scan_position_y

      consume(xeno_hit)
    end

    private

    def consume(xeno_hit)
      xeno_data = xeno_hit.xeno_instance.xeno_signature

      xeno_data.each_with_index do |xeno_row_data, xeno_y|
        next if xeno_y < xeno_hit.xeno_y_start

        xeno_row = xeno_row_data.split(//)
        xeno_row.each_with_index do |xeno_char, xeno_x|
          global_x = xeno_hit.radar_x_position + xeno_x
          global_y = xeno_hit.radar_y_position + xeno_y - xeno_hit.xeno_y_start

          @hit_matrix_cache[cache_key(global_x, global_y)] = xeno_char
        end
      end
    end

    def get_cache(x, y)
      @hit_matrix_cache[cache_key(x, y)]
    end

    def cache_key(x, y)
      "#{x}::#{y}"
    end
  end

  class Hit
    attr_accessor :radar_x_position,
                  :radar_y_position,
                  :xeno_instance,
                  :xeno_y_start

    def initialize(xeno_instance, xeno_y_start = 0)
      @xeno_instance = xeno_instance
      @xeno_y_start = xeno_y_start
    end
  end
end