require 'geocoder'

class SlidingWindow
  def initialize
    @points = []
    @dist = 0

    Geocoder.configure(units: :km)
  end

  def time
    @points.last.time - @points.first.time
  end

  def distance
    @dist
  end

  def <<(point)
    last_point = @points.last
    unless last_point.nil?
      @dist += Geocoder::Calculations.distance_between([last_point.lat, last_point.lon], [point.lat, point.lon])
    end
    @points << point
  end

  def shift
    old_point = @points.shift
    @dist -= Geocoder::Calculations.distance_between([old_point.lat, old_point.lon], [@points.first.lat, @points.first.lon])
  end
end