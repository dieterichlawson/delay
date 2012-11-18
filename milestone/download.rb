#!/usr/bin/env ruby
require 'configliere'
require 'set'

Settings.use :commandline

Settings.define :year, flag: 'y', description: 'Retrieve this year', type: Integer, default: 2012
Settings.define :month, flag: 'm', description: "Retrieve only this month", default: nil
Settings.define :out_dir, flag: 'o', description: "Place files in this directory", default: File.dirname(__FILE__)
Settings.define :unzip, flag: 'u', description: "Extract the files and remove the original zip files", default: true
Settings.define :post_process, flag: 'p', description: "Process the files after they are downloaded", default: true
Settings.resolve!

MONTHS =  %q{January February March April May June July August September October November December}.split

def get_post_params(year,month,month_num)
  "UserTableName=On_Time_Performance&DBShortName=&RawDataTable=T_ONTIME&sqlstr=+SELECT+MONTH%2CDAY_OF_MONTH%2CDAY_OF_WEEK%2CUNIQUE_CARRIER%2CORIGIN%2CDEST%2CCRS_DEP_TIME%2CDEP_DELAY_NEW%2CDEP_DEL15%2CDISTANCE+FROM++T_ONTIME+WHERE+Month+%3D#{month_num}+AND+YEAR%3D#{year}&varlist=MONTH%2CDAY_OF_MONTH%2CDAY_OF_WEEK%2CUNIQUE_CARRIER%2CORIGIN%2CDEST%2CCRS_DEP_TIME%2CDEP_DELAY_NEW%2CDEP_DEL15%2CDISTANCE&grouplist=&suml=&sumRegion=&filter1=title%3D&filter2=title%3D&geo=All%A0&time=#{month}&timename=Month&GEOGRAPHY=All&XYEAR=#{year}&FREQUENCY=1&VarDesc=Year&VarType=Num&VarDesc=Quarter&VarType=Num&VarName=MONTH&VarDesc=Month&VarType=Num&VarName=DAY_OF_MONTH&VarDesc=DayofMonth&VarType=Num&VarName=DAY_OF_WEEK&VarDesc=DayOfWeek&VarType=Num&VarDesc=FlightDate&VarType=Char&VarName=UNIQUE_CARRIER&VarDesc=UniqueCarrier&VarType=Char&VarDesc=AirlineID&VarType=Num&VarDesc=Carrier&VarType=Char&VarDesc=TailNum&VarType=Char&VarDesc=FlightNum&VarType=Char&VarDesc=OriginAirportID&VarType=Num&VarDesc=OriginAirportSeqID&VarType=Num&VarDesc=OriginCityMarketID&VarType=Num&VarName=ORIGIN&VarDesc=Origin&VarType=Char&VarDesc=OriginCityName&VarType=Char&VarDesc=OriginState&VarType=Char&VarDesc=OriginStateFips&VarType=Char&VarDesc=OriginStateName&VarType=Char&VarDesc=OriginWac&VarType=Num&VarDesc=DestAirportID&VarType=Num&VarDesc=DestAirportSeqID&VarType=Num&VarDesc=DestCityMarketID&VarType=Num&VarName=DEST&VarDesc=Dest&VarType=Char&VarDesc=DestCityName&VarType=Char&VarDesc=DestState&VarType=Char&VarDesc=DestStateFips&VarType=Char&VarDesc=DestStateName&VarType=Char&VarDesc=DestWac&VarType=Num&VarName=CRS_DEP_TIME&VarDesc=CRSDepTime&VarType=Char&VarDesc=DepTime&VarType=Char&VarDesc=DepDelay&VarType=Num&VarName=DEP_DELAY_NEW&VarDesc=DepDelayMinutes&VarType=Num&VarName=DEP_DEL15&VarDesc=DepDel15&VarType=Num&VarDesc=DepartureDelayGroups&VarType=Num&VarDesc=DepTimeBlk&VarType=Char&VarDesc=TaxiOut&VarType=Num&VarDesc=WheelsOff&VarType=Char&VarDesc=WheelsOn&VarType=Char&VarDesc=TaxiIn&VarType=Num&VarDesc=CRSArrTime&VarType=Char&VarDesc=ArrTime&VarType=Char&VarDesc=ArrDelay&VarType=Num&VarDesc=ArrDelayMinutes&VarType=Num&VarDesc=ArrDel15&VarType=Num&VarDesc=ArrivalDelayGroups&VarType=Num&VarDesc=ArrTimeBlk&VarType=Char&VarDesc=Cancelled&VarType=Num&VarDesc=CancellationCode&VarType=Char&VarDesc=Diverted&VarType=Num&VarDesc=CRSElapsedTime&VarType=Num&VarDesc=ActualElapsedTime&VarType=Num&VarDesc=AirTime&VarType=Num&VarDesc=Flights&VarType=Num&VarName=DISTANCE&VarDesc=Distance&VarType=Num&VarDesc=DistanceGroup&VarType=Num&VarDesc=CarrierDelay&VarType=Num&VarDesc=WeatherDelay&VarType=Num&VarDesc=NASDelay&VarType=Num&VarDesc=SecurityDelay&VarType=Num&VarDesc=LateAircraftDelay&VarType=Num&VarDesc=FirstDepTime&VarType=Char&VarDesc=TotalAddGTime&VarType=Num&VarDesc=LongestAddGTime&VarType=Num&VarDesc=DivAirportLandings&VarType=Num&VarDesc=DivReachedDest&VarType=Num&VarDesc=DivActualElapsedTime&VarType=Num&VarDesc=DivArrDelay&VarType=Num&VarDesc=DivDistance&VarType=Num&VarDesc=Div1Airport&VarType=Char&VarDesc=Div1AirportID&VarType=Num&VarDesc=Div1AirportSeqID&VarType=Num&VarDesc=Div1WheelsOn&VarType=Char&VarDesc=Div1TotalGTime&VarType=Num&VarDesc=Div1LongestGTime&VarType=Num&VarDesc=Div1WheelsOff&VarType=Char&VarDesc=Div1TailNum&VarType=Char&VarDesc=Div2Airport&VarType=Char&VarDesc=Div2AirportID&VarType=Num&VarDesc=Div2AirportSeqID&VarType=Num&VarDesc=Div2WheelsOn&VarType=Char&VarDesc=Div2TotalGTime&VarType=Num&VarDesc=Div2LongestGTime&VarType=Num&VarDesc=Div2WheelsOff&VarType=Char&VarDesc=Div2TailNum&VarType=Char&VarDesc=Div3Airport&VarType=Char&VarDesc=Div3AirportID&VarType=Num&VarDesc=Div3AirportSeqID&VarType=Num&VarDesc=Div3WheelsOn&VarType=Char&VarDesc=Div3TotalGTime&VarType=Num&VarDesc=Div3LongestGTime&VarType=Num&VarDesc=Div3WheelsOff&VarType=Char&VarDesc=Div3TailNum&VarType=Char&VarDesc=Div4Airport&VarType=Char&VarDesc=Div4AirportID&VarType=Num&VarDesc=Div4AirportSeqID&VarType=Num&VarDesc=Div4WheelsOn&VarType=Char&VarDesc=Div4TotalGTime&VarType=Num&VarDesc=Div4LongestGTime&VarType=Num&VarDesc=Div4WheelsOff&VarType=Char&VarDesc=Div4TailNum&VarType=Char&VarDesc=Div5Airport&VarType=Char&VarDesc=Div5AirportID&VarType=Num&VarDesc=Div5AirportSeqID&VarType=Num&VarDesc=Div5WheelsOn&VarType=Char&VarDesc=Div5TotalGTime&VarType=Num&VarDesc=Div5LongestGTime&VarType=Num&VarDesc=Div5WheelsOff&VarType=Char&VarDesc=Div5TailNum&VarType=Char"
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
  #`sed -i '' 's/,/	/g' #{out_dir}/#{month}-#{year}.csv` #remove commas
  `sed -i '' '1d' #{out_dir}/#{month}-#{year}.csv`      #remove header
  #`mv #{out_dir}/#{month}-#{year}.csv #{out_dir}/#{month}-#{year}.tsv`
  puts "Categorizing...."
  categorize("#{out_dir}/#{month}-#{year}.csv", "#{out_dir}/#{month}-#{year}.csv.tmp",[3,4,5])
end

def categorize(in_file, out_file, columns)
  f = open(in_file)
  o = File.open(out_file, 'w')
  types = {}
  mappings = {}
  columns.each do |column|
    types[column] = Set.new
    mappings[column] = {}
  end
  f.each_line do |line|
    line = line.split(',')
    columns.each do |column|
      unless types[column].include? line[column]
        types[column].add line[column]
        mappings[column][line[column]] = types[column].size
      end
      line[column] = mappings[column][line[column]]
    end
    line.each_with_index do |col,index|
      line[index] = "0.00" if col ==""
    end
    o.write(line.join(','))
  end
  o.close
  f.close
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
