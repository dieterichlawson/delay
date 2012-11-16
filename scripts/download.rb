#!/usr/bin/env ruby
require 'configliere'

Settings.use :commandline

Settings.define :year, flag: 'y', description: 'Retrieve this year', type: Integer, default: 2012
Settings.define :month, flag: 'm', description: "Retrieve only this month", default: nil
Settings.define :out_dir, flag: 'o', description: "Place files in this directory", default: File.dirname(__FILE__)
Settings.define :unzip, flag: 'u', description: "Extract the files and remove the original zip files", default: true
Settings.define :post_process, flag: 'p', description: "process the files after they are downloaded", default: true
Settings.resolve!

MONTHS =  %q{January February March April May June July August September October November December}.split

def get_post_params(year,month,month_num)
  "UserTableName=On_Time_Performance&DBShortName=&RawDataTable=T_ONTIME&sqlstr=+SELECT+YEAR%2CMONTH%2CDAY_OF_MONTH%2CDAY_OF_WEEK%2CFL_DATE%2CUNIQUE_CARRIER%2CAIRLINE_ID%2CCARRIER%2CTAIL_NUM%2CFL_NUM%2CORIGIN_AIRPORT_ID%2CORIGIN_AIRPORT_SEQ_ID%2CORIGIN_CITY_MARKET_ID%2CORIGIN%2CORIGIN_STATE_ABR%2CDEST_AIRPORT_ID%2CDEST_AIRPORT_SEQ_ID%2CDEST_CITY_MARKET_ID%2CDEST%2CDEST_STATE_ABR%2CCRS_DEP_TIME%2CDEP_TIME%2CDEP_DELAY%2CDEP_DELAY_NEW%2CDEP_DEL15%2CTAXI_OUT%2CWHEELS_OFF%2CWHEELS_ON%2CTAXI_IN%2CCRS_ARR_TIME%2CARR_TIME%2CARR_DELAY%2CARR_DELAY_NEW%2CARR_DEL15%2CCANCELLED%2CCANCELLATION_CODE%2CDIVERTED%2CCRS_ELAPSED_TIME%2CACTUAL_ELAPSED_TIME%2CAIR_TIME%2CDISTANCE%2CCARRIER_DELAY%2CWEATHER_DELAY%2CNAS_DELAY%2CSECURITY_DELAY%2CLATE_AIRCRAFT_DELAY+FROM++T_ONTIME+WHERE+Month+%3D#{month_num}+AND+YEAR%3D#{year}&varlist=YEAR%2CMONTH%2CDAY_OF_MONTH%2CDAY_OF_WEEK%2CFL_DATE%2CUNIQUE_CARRIER%2CAIRLINE_ID%2CCARRIER%2CTAIL_NUM%2CFL_NUM%2CORIGIN_AIRPORT_ID%2CORIGIN_AIRPORT_SEQ_ID%2CORIGIN_CITY_MARKET_ID%2CORIGIN%2CORIGIN_STATE_ABR%2CDEST_AIRPORT_ID%2CDEST_AIRPORT_SEQ_ID%2CDEST_CITY_MARKET_ID%2CDEST%2CDEST_STATE_ABR%2CCRS_DEP_TIME%2CDEP_TIME%2CDEP_DELAY%2CDEP_DELAY_NEW%2CDEP_DEL15%2CTAXI_OUT%2CWHEELS_OFF%2CWHEELS_ON%2CTAXI_IN%2CCRS_ARR_TIME%2CARR_TIME%2CARR_DELAY%2CARR_DELAY_NEW%2CARR_DEL15%2CCANCELLED%2CCANCELLATION_CODE%2CDIVERTED%2CCRS_ELAPSED_TIME%2CACTUAL_ELAPSED_TIME%2CAIR_TIME%2CDISTANCE%2CCARRIER_DELAY%2CWEATHER_DELAY%2CNAS_DELAY%2CSECURITY_DELAY%2CLATE_AIRCRAFT_DELAY&grouplist=&suml=&sumRegion=&filter1=title%3D&filter2=title%3D&geo=All%A0&time=#{month}&timename=Month&GEOGRAPHY=All&XYEAR=#{year}&FREQUENCY=1&VarName=YEAR&VarDesc=Year&VarType=Num&VarDesc=Quarter&VarType=Num&VarName=MONTH&VarDesc=Month&VarType=Num&VarName=DAY_OF_MONTH&VarDesc=DayofMonth&VarType=Num&VarName=DAY_OF_WEEK&VarDesc=DayOfWeek&VarType=Num&VarName=FL_DATE&VarDesc=FlightDate&VarType=Char&VarName=UNIQUE_CARRIER&VarDesc=UniqueCarrier&VarType=Char&VarName=AIRLINE_ID&VarDesc=AirlineID&VarType=Num&VarName=CARRIER&VarDesc=Carrier&VarType=Char&VarName=TAIL_NUM&VarDesc=TailNum&VarType=Char&VarName=FL_NUM&VarDesc=FlightNum&VarType=Char&VarName=ORIGIN_AIRPORT_ID&VarDesc=OriginAirportID&VarType=Num&VarName=ORIGIN_AIRPORT_SEQ_ID&VarDesc=OriginAirportSeqID&VarType=Num&VarName=ORIGIN_CITY_MARKET_ID&VarDesc=OriginCityMarketID&VarType=Num&VarName=ORIGIN&VarDesc=Origin&VarType=Char&VarDesc=OriginCityName&VarType=Char&VarName=ORIGIN_STATE_ABR&VarDesc=OriginState&VarType=Char&VarDesc=OriginStateFips&VarType=Char&VarDesc=OriginStateName&VarType=Char&VarDesc=OriginWac&VarType=Num&VarName=DEST_AIRPORT_ID&VarDesc=DestAirportID&VarType=Num&VarName=DEST_AIRPORT_SEQ_ID&VarDesc=DestAirportSeqID&VarType=Num&VarName=DEST_CITY_MARKET_ID&VarDesc=DestCityMarketID&VarType=Num&VarName=DEST&VarDesc=Dest&VarType=Char&VarDesc=DestCityName&VarType=Char&VarName=DEST_STATE_ABR&VarDesc=DestState&VarType=Char&VarDesc=DestStateFips&VarType=Char&VarDesc=DestStateName&VarType=Char&VarDesc=DestWac&VarType=Num&VarName=CRS_DEP_TIME&VarDesc=CRSDepTime&VarType=Char&VarName=DEP_TIME&VarDesc=DepTime&VarType=Char&VarName=DEP_DELAY&VarDesc=DepDelay&VarType=Num&VarName=DEP_DELAY_NEW&VarDesc=DepDelayMinutes&VarType=Num&VarName=DEP_DEL15&VarDesc=DepDel15&VarType=Num&VarDesc=DepartureDelayGroups&VarType=Num&VarDesc=DepTimeBlk&VarType=Char&VarName=TAXI_OUT&VarDesc=TaxiOut&VarType=Num&VarName=WHEELS_OFF&VarDesc=WheelsOff&VarType=Char&VarName=WHEELS_ON&VarDesc=WheelsOn&VarType=Char&VarName=TAXI_IN&VarDesc=TaxiIn&VarType=Num&VarName=CRS_ARR_TIME&VarDesc=CRSArrTime&VarType=Char&VarName=ARR_TIME&VarDesc=ArrTime&VarType=Char&VarName=ARR_DELAY&VarDesc=ArrDelay&VarType=Num&VarName=ARR_DELAY_NEW&VarDesc=ArrDelayMinutes&VarType=Num&VarName=ARR_DEL15&VarDesc=ArrDel15&VarType=Num&VarDesc=ArrivalDelayGroups&VarType=Num&VarDesc=ArrTimeBlk&VarType=Char&VarName=CANCELLED&VarDesc=Cancelled&VarType=Num&VarName=CANCELLATION_CODE&VarDesc=CancellationCode&VarType=Char&VarName=DIVERTED&VarDesc=Diverted&VarType=Num&VarName=CRS_ELAPSED_TIME&VarDesc=CRSElapsedTime&VarType=Num&VarName=ACTUAL_ELAPSED_TIME&VarDesc=ActualElapsedTime&VarType=Num&VarName=AIR_TIME&VarDesc=AirTime&VarType=Num&VarDesc=Flights&VarType=Num&VarName=DISTANCE&VarDesc=Distance&VarType=Num&VarDesc=DistanceGroup&VarType=Num&VarName=CARRIER_DELAY&VarDesc=CarrierDelay&VarType=Num&VarName=WEATHER_DELAY&VarDesc=WeatherDelay&VarType=Num&VarName=NAS_DELAY&VarDesc=NASDelay&VarType=Num&VarName=SECURITY_DELAY&VarDesc=SecurityDelay&VarType=Num&VarName=LATE_AIRCRAFT_DELAY&VarDesc=LateAircraftDelay&VarType=Num&VarDesc=FirstDepTime&VarType=Char&VarDesc=TotalAddGTime&VarType=Num&VarDesc=LongestAddGTime&VarType=Num&VarDesc=DivAirportLandings&VarType=Num&VarDesc=DivReachedDest&VarType=Num&VarDesc=DivActualElapsedTime&VarType=Num&VarDesc=DivArrDelay&VarType=Num&VarDesc=DivDistance&VarType=Num&VarDesc=Div1Airport&VarType=Char&VarDesc=Div1AirportID&VarType=Num&VarDesc=Div1AirportSeqID&VarType=Num&VarDesc=Div1WheelsOn&VarType=Char&VarDesc=Div1TotalGTime&VarType=Num&VarDesc=Div1LongestGTime&VarType=Num&VarDesc=Div1WheelsOff&VarType=Char&VarDesc=Div1TailNum&VarType=Char&VarDesc=Div2Airport&VarType=Char&VarDesc=Div2AirportID&VarType=Num&VarDesc=Div2AirportSeqID&VarType=Num&VarDesc=Div2WheelsOn&VarType=Char&VarDesc=Div2TotalGTime&VarType=Num&VarDesc=Div2LongestGTime&VarType=Num&VarDesc=Div2WheelsOff&VarType=Char&VarDesc=Div2TailNum&VarType=Char&VarDesc=Div3Airport&VarType=Char&VarDesc=Div3AirportID&VarType=Num&VarDesc=Div3AirportSeqID&VarType=Num&VarDesc=Div3WheelsOn&VarType=Char&VarDesc=Div3TotalGTime&VarType=Num&VarDesc=Div3LongestGTime&VarType=Num&VarDesc=Div3WheelsOff&VarType=Char&VarDesc=Div3TailNum&VarType=Char&VarDesc=Div4Airport&VarType=Char&VarDesc=Div4AirportID&VarType=Num&VarDesc=Div4AirportSeqID&VarType=Num&VarDesc=Div4WheelsOn&VarType=Char&VarDesc=Div4TotalGTime&VarType=Num&VarDesc=Div4LongestGTime&VarType=Num&VarDesc=Div4WheelsOff&VarType=Char&VarDesc=Div4TailNum&VarType=Char&VarDesc=Div5Airport&VarType=Char&VarDesc=Div5AirportID&VarType=Num&VarDesc=Div5AirportSeqID&VarType=Num&VarDesc=Div5WheelsOn&VarType=Char&VarDesc=Div5TotalGTime&VarType=Num&VarDesc=Div5LongestGTime&VarType=Num&VarDesc=Div5WheelsOff&VarType=Char&VarDesc=Div5TailNum&VarType=Char"
end

def download(year,month,out_dir)
  puts "Downloading #{month}"
  `curl -L -d "#{get_post_params(year,month,MONTHS.index(month)+1)}" 'http://www.transtats.bts.gov/DownLoad_Table.asp?Table_ID=236&Has_Group=3&Is_Zipped=0' > #{out_dir}/#{month}-#{year}.zip`
end


def unzip(year, month, out_dir)
  puts "Unzipping #{month}"
  `unzip -p #{out_dir}/#{month}-#{year}.zip > #{out_dir}/#{month}-#{year}.csv`
  `rm #{out_dir}/#{month}-#{year}.zip`
end

def post_process(year,month,out_dir)
   puts "Postprocessing #{month}"
   `sed -i '' 's/"//g' #{out_dir}/#{month}-#{year}.csv`  #remove quotes
   `sed -i '' 's/,/	/g' #{out_dir}/#{month}-#{year}.csv` #remove commas
   `sed -i '' '1d' #{out_dir}/#{month}-#{year}.csv`      #remove header
   `mv #{out_dir}/#{month}-#{year}.csv #{out_dir}/#{month}-#{year}.tsv`
end

if Settings.month.nil?
  MONTHS.each_with_index do |month,index|
    download(Settings.year,month,Settings.out_dir)
    unzip(Settings.year,month,Settings.out_dir) if Settings.unzip
    post_process(Settings.year,month,Settings.out_dir) if Settings.post_process 
  end
else
  download(Settings.year,Settings.month,Settings.out_dir)
  unzip(Settings.year,Settings.month,Settings.out_dir) if Settings.unzip
  post_process(Settings.year,Settings.month,Settings.out_dir) if Settings.post_process 
end
