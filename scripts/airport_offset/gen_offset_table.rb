#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'configliere'

# Ingests the airport table and spits out
# the same table but with dst / raw UTC offsets
# added.

Settings.use :commandline
Settings.define :in_file, description: "Input airport CSV file", default: "airports_raw.csv"
Settings.define :out_file, description: "File to put output into", default: "airport_offsets.csv"
Settings.define :ignore_header, flag: 'i', description: "Ignore the first line of the file", default: true

Settings.resolve!

AIRPORT_ID = 1
LAT = 3
LONG = 4
UTC_OFFSET = 5

in = open(Settings.in_file)
out = File.open(Settings.out_file,'w')

def offset_to_s(offset)
  hrs = offset.to_i
  mins = (offset.to_f - hrs).abs*60
  "#{hrs < 0 ? '-' : '+'}%02d:%02d" % [hrs.abs, mins]
end

def get_offsets(lat,long,airport_id)
  @offsets_by_id ||={}
  if @offsets_by_id.has_key? airport_id # we have it memoized
    @offsets_by_id[airport_id]
  else # we have to talk to geonames
    response = Net::HTTP.get_response("api.geonames.org","/timezoneJSON?lat=#{lat}&lng=#{long}&username=dieterichlawson")
    response = JSON.parse(response.body)
    # check for errors
    if response.has_key? 'message' and response.has_key? 'value'
      if response['value'] == 15
        puts "Hit hourly API limit..."
      else
        puts "Unknown API error occurred.\n Message:#{response['message']}\n value:#{response['value']}"
      end
      exit 
    end
    @offsets_by_id[airport_id] = [response["gmtOffset"],response["dstOffset"]]
    @offsets_by_id[airport_id]
  end
end

if Settings.ignore_header
  #TODO: increment n by 1 line 
end

# iterate through input file
in.each_line do |line|
  next if #TODO: check if it's not USA
  line = line.split(',')
  gmtOffset, dstOffset = get_offsets(line[LAT],line[LONG],line[AIRPORT_ID])
  # replace offset with geonames GMT offset
  line[UTC_OFFSET] = offset_to_s(gmtOffset)
  # add geonames DST offset
  line.insert(UTC_OFFSET+1,offset_to_s(dstOffset))
  out.write(line.join("\t"))
end

#cleanup
in.close
out.close
