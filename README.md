# geolocation_proxycheck
The geolocation_proxycheck script is used to geolocate IP adresses from CSV file by two databases the MaxMind GeoIP and the IP2Location IP2Lite. Script can be also used to check IP adresses on proxy by the IP2Location IP2Proxy database. 
Input CSV file must have header with "ip" column. Output file contains: 

- Country Code 
- Country Name
- Latitude & Longitude
- Proxy Type

## Installation 
Ruby and Bundler installation is required. After that run inside project from your command line:
```ruby
$ bundle install
```
## Usage

- For help run this command:
```ruby
$ ./geolocation_service.rb -h
```

- Help output:
```ruby
   usage: geolocation_service.rb [options]
    -h, --help         Show help.
    -u, --update       Update all databases.
    -up, --updatep     Update proxy database.
    -ul, --updateip2   Update IP2Location database.
    -um, --updatemm    Update MaxMind database.
    -i, --input        Add name of inputfile with data.
    -m, --maxmind      Geolocate by MaxMind.
    -l, --ip2location  Geolocate by IP2Location.
    -p, --proxy        Check proxy.
    -v, --visualize    Create a visualisation map.
```

- Update all databases:
```ruby
$ ./geolocation_service.rb -u
```

- Update MaxMind database:
```ruby
$ ./geolocation_service.rb -um
```

- Update IP2Location database:
```ruby
$ ./geolocation_service.rb -ul
```

- Update proxy database:
```ruby
$ ./geolocation_service.rb -up
```

- Geolocate IP adresses stored in CSV file by free MaxMind GeoLite2 City Database:
```ruby
$ ./geolocation_service.rb -i example.csv -m
```


- Geolocate IP adresses stored in CSV file by free IP2Location LITE IP-COUNTRY-REGION-CITY-LATITUDE-LONGITUDE Database:
```ruby
$ ./geolocation_service.rb -i example.csv -l
```

- Check IP adresses on proxy by free IP2Location IP2Proxy LITE IP-COUNTRY Database:
```ruby
$ ./geolocation_service.rb -i example.csv -p
```

- Visualise output data on map:
```ruby
$ ./geolocation_service.rb -i example.csv -v
```

## Used databases:
This aplicaton includes:

- IP2Location LITE data available from <a href="http://lite.ip2location.com">http://lite.ip2location.com</a>.
- GeoLite2 data created by MaxMind, available from <a href="http://www.maxmind.com">http://www.maxmind.com</a>.
