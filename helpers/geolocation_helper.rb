#!/usr/bin/ruby

require 'csv'
require "ipaddress"
require 'maxminddb'
require 'ip2location_ruby'
require 'ip2proxy_ruby'
require 'ruby-progressbar'
require './helpers/draw_helper'

# Class with all geolocation functionality
class GeolocationHelper

  # Setup filename and other options
  #
  # @parem [String, #filename]  name of file with input data
  # @param [Boolean, #mm]       true value switchs on MaxMind geolocation
  # @param [Boolean, #ip2]      true value switchs on IP2Location geolocation
  # @param [Boolean, #prox]     true value switchs on Proxy check geolocation
  # @param [Boolean, #v]        true value switchs on Visulisation on a map
  def initialize (filename, mm, ip2, prox, v)
    @filename = filename
    @mm = mm
    @ip2 = ip2
    @prox = prox
    @viz = v
    @progressbar = ProgressBar.create( :format         => "%a %b\u{15E7}%i %p%%  Processed: %c from %C",
                    :progress_mark  => ' ',
                    :remainder_mark => "\u{FF65}",
                    :starting_at    => 1,
                    :total => CSV.read(filename).length)
  end

  # Function geolocates data or checks proxy and save result to file: "aplication_output.csv"
  def processData
    openDatabases
    header = prepareHeader

    # Open new visual. maps
    if @viz
      map_ip2l = DrawHelper.new if @ip2
      map_mm = DrawHelper.new if @mm
    end

    CSV.open("aplication_output.csv", "wb",:write_headers=> true,:headers => header ) do |output|
      CSV.foreach(@filename, headers:true) do |row|
        if IPAddress.valid? row['ip'] 
          record_mm = @d_mm.lookup(row['ip']) if @mm
          record_ip2l = @d_ip2l.get_all(row['ip']) if @ip2
          record_proxy = @d_ip2p.getAll(row['ip']) if @prox

          if @viz
            map_mm.add_point(record_mm.location.latitude, record_mm.location.longitude) if @mm
            map_ip2l.add_point(record_ip2l.latitude, record_ip2l.longitude) if @ip2
          end

          temp_row = [row['id'], row['ip']]
          temp_row += [record_mm.country.iso_code, record_mm.country.name, record_mm.location.latitude, record_mm.location.longitude] if @mm
          temp_row += [record_ip2l.country_short, record_ip2l.country_long, record_ip2l.latitude, record_ip2l.longitude] if @ip2
          temp_row += [record_proxy['proxy_type']] if @prox

          output << temp_row
        else
          output << [row['id'], row['ip'], "wrong_ip"]
        end
        @progressbar.increment
      end
    end 
    @d_ip2p.close if @prox

    #save visualisation maps
    if @viz
      map_mm.save 'MaxMind_map.png' if @mm
      map_ip2l.save 'IP2Location_map.png' if @ip2
    end
  end
  
  private

  # Open GeoIP and Proxy databases
  def openDatabases
    @d_mm = MaxMindDB.new('./database/GeoLite2-City.mmdb') if @mm
    @d_ip2l = Ip2location.new.open("../database/IP2LOCATION-LITE-DB5.BIN") if @ip2
    @d_ip2p = Ip2proxy.new.open("../database/IP2PROXY-LITE-PX2.BIN") if @prox
  end

  # Prepare CSV header for output file
  # 
  # @return [Array, #header] new CSV header
  def prepareHeader
    header = ['id','ip']
    header += ["country_iso_code_maxmind","country_maxmind","latitude_maxmind","longitude_maxmind"] if @mm
    header += ["country_iso_code_ip2location","country_ip2location","latitude_ip2location","longitude_ip2location"] if @ip2
    header += ["proxy_type"] if @prox   
    return header
  end

end
