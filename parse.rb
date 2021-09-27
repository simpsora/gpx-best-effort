#!/usr/bin/env ruby

require 'set'
require 'time'
require 'nokogiri'

require_relative 'sliding_window.rb'

TARGET = 5.0

Point = Struct.new(:lat, :lon, :time)

if ARGV.count < 1
  puts "Usage: #{__FILE__} GPX_FILE\n\n"
  exit 1
end

doc = Nokogiri::XML(File.open(ARGV[0]))
points = doc.xpath('//xmlns:trkpt')
puts "Loaded #{points.count} points from gpx file"
window = SlidingWindow.new

achievements = Set.new

points.each_with_index do |point, idx|
  p = Point.new(point["lat"].to_f, point["lon"].to_f, Time.parse(point.xpath("xmlns:time").first.children.first.to_s))

  dist = window.distance

  #puts "[#{idx}] lat=#{p.lat}, lon=#{p.lon}, time=#{p.time}, dist=#{dist}"

  if dist >= TARGET
    achievements << window.time
    window.shift
  else
    window << p
  end
end

fastest = Time.at(achievements.min.to_i).utc.strftime("%H:%M:%S")
puts "#{achievements.count} #{TARGET}km achievements, fastest in #{fastest}."
