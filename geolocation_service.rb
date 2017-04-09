#!/usr/bin/env ruby

require "slop"
require "./helpers/database_helper"
require "./helpers/geolocation_helper"

# Geolocation service
# Aplication reacts to ARGV arguments, geolocate or check proxy on input file
# 
# #example ./geolocation_service.rb -u
# #example ./geolocation_service.rb -i example.csv -m -l -p
module Geolocation_service
  include DatabaseHelper
  opts = Slop.parse do |o|
    o.on '-h',     '--help',        'Show help.'
    o.bool '-u',   '--update',      'Update all databases.'
    o.bool '-up',  '--updatep',     'Update proxy database.'
    o.bool '-ul',  '--updateip2',   'Update IP2Location database.'
    o.bool '-um',  '--updatemm',    'Update MaxMind database.'
    o.string '-i', '--input',       'Add name of inputfile with data.'
    o.bool '-m',   '--maxmind',     'Geolocate by MaxMind.'
    o.bool '-l',   '--ip2location', 'Geolocate by IP2Location.'
    o.bool '-p',   '--proxy',       'Check proxy.'
  end

  # Downlaod or update GeoIP and proxy databases.
  if opts[:u]
    puts "--> Updating databases..."
    DatabaseHelper.getAllDatabases
    puts "--> Dadabases successfully updated."
  end

  # Download proxy database
  if opts[:up]
    puts "--> Updating proxy database..."
    DatabaseHelper.downlaodProxyDatabase
    puts "--> Dadabase successfully updated."
  end

  # Download IP2Location database
  if opts[:ul]
    puts "--> Updating IP2Location databases..."
    DatabaseHelper.downlaodIp2LocationDatabase
    puts "--> Dadabase successfully updated."
  end

  # Download MaxMind database
  if opts[:um]
    puts "--> Updating MaxMind databases..."
    DatabaseHelper.downloadMaxMindDatabase
    puts "--> Dadabase successfully updated."
  end

  # Geolocate or check proxy on input file.
  if opts[:i]
    if opts[:m] or opts[:l] or opts[:p]
      puts "--> Proces started..."
      GeolocationHelper.new(opts[:i], opts[:m], opts[:l], opts[:p]).processData
      puts '--> Geolocation successfully finished.'
    else
      puts "--> No option selected!"
      puts "--> Starting default geolocation with MaxMind and IP2Location without Proxy..."
      GeolocationHelper.new(opts[:i], true, true, false).processData
      puts '--> Geolocation successfully finished.'
    end
  end

  if (opts[:m] or opts[:l] or opts[:p]) and opts[:i] == nil
    puts 'Missing input file!'
  end

  # Print help.
  if opts[:h]
    puts opts
  end
end