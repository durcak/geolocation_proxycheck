#!/usr/bin/ruby

require 'chunky_png'
require 'csv'

# Class visualisate data on map
class DrawHelper

  # Open map and point
  def initialize
    @picture = ChunkyPNG::Image.from_file('./helpers/map.png')
		@point  = ChunkyPNG::Image.from_file('./helpers/point.png')
  end

  # Add point to map on given coordinates
  #
  # @parem [Float, #lat]  value with latitude
  # @param [Float, #lon]  value with longitude
  def add_point lat, lon
  	@picture.compose!(@point, count_x(lon.to_f), count_y(lat.to_f))
  end

  # Save map to file
  #
  # @param [String, #filename] name of file to save new map
  def save filename
		@picture.save(filename, :interlace => true)
  end

  private

  # Count X value from given longitude
  #
  # @parem [Float, #lon]  value with longitude
  # @return [Integer] counted X value
  def count_x lon
	  pos = lon+170 
	  x = 6372*pos/227.509
	  return (x/10).to_i
	end

  # Count Y value from given latitude
  #
  # @parem [Float, #lat]  value with latitude
  # @return [Integer] counted Y value
	def count_y lat
	  pos = lat+10.45 
	  x = 279*pos/(-8.99)+4911
	  return (x/10).to_i
	end
end