module Randomize
  def randomize_data(data)
    data.collect do |row|
      random_index = rand(0..(row.size - 1))
      row[random_index] = 'o'.eql?(row[random_index]) ? '-' : 'o'
      row
    end
  end
end
