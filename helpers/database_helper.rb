require 'rubygems/package'
require 'zip'
require 'zlib' 
require 'open-uri'
require 'rubygems'

# DatabaseHelper module download databases from Internet
module DatabaseHelper
  MAXMIND_URL = "http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz"
  IP2PROXY_URL = uri = "https://www.ip2location.com/download?productcode=PX2LITEBIN&login=geolocation@europe.com&password=KzSfbeZjpp9Q"
  IP2LOCATION_URL = uri = "https://www.ip2location.com/download?productcode=DB5LITEBIN&login=geolocation@europe.com&password=KzSfbeZjpp9Q"
  
  class << self
    def getAllDatabases
      downloadMaxMindDatabase
      downlaodProxyDatabase
      downlaodIp2LocationDatabase
    end

    # Download and unzip MaxMind database
    #
    def downloadMaxMindDatabase
      getMaxMindDatabase
    end

    # Download and unzip Proxy database 
    #
    def downlaodProxyDatabase
      getI2LocationDatabase IP2PROXY_URL
    end

    # Download and unzip Ip2Location database
    #
    def downlaodIp2LocationDatabase
      getI2LocationDatabase IP2LOCATION_URL
    end

  private
    # Download MaxMind database from MAXMIND_URL and unzip it into database folder
    # 
    # @param [String, #fileName] filename to unzip
    def getMaxMindDatabase
      uri = MAXMIND_URL
      source = open(uri)

      Zlib::GzipReader.open(source) do | input_stream |
        f_path=File.join("database", "GeoLite2-City.mmdb")
        FileUtils.mkdir_p(File.dirname(f_path))
        File.open(f_path, "w") do |output_stream|
          IO.copy_stream(input_stream, output_stream)
        end
      end
    end

    # Download IP2Location database from given url and unzip it into database folder
    # 
    # @param [String, #url] url with location of database
    def getI2LocationDatabase (url)
      source = open(url)
      Zip::File.open(source) { |zip_file|
         zip_file.each { |f|
         f_path=File.join("database", f.name)
         FileUtils.mkdir_p(File.dirname(f_path))
         zip_file.extract(f, f_path) unless File.exist?(f_path)
       }
      }
    end
  end
end
