#!/usr/bin/env ruby

require 'date'
@airCodes = {}
File.open('airports.csv', 'r') do |file|
    file.each_line do |line|
          line_data = line.split(/\s/)
          key = line_data[0].to_s
          @airCodes[key] = [line_data[1], line_data[2]]
          end
end

DST = {2003 => [Date.parse("2003-04-06"),Date.parse("2003-10-26")]}
DST[2004] = [Date.parse("2004-04-04"), Date.parse("2004-10-31")]
DST[2005] = [Date.parse("2005-04-03"), Date.parse("2005-10-30")]
DST[2006] = [Date.parse("2006-04-02"), Date.parse("2006-10-29")]
DST[2007] = [Date.parse("2007-03-11"), Date.parse("2007-11-04")]
DST[2008] = [Date.parse("2008-03-09"), Date.parse("2008-11-02")]
DST[2009] = [Date.parse("2009-03-08"), Date.parse("2009-11-01")]
DST[2010] = [Date.parse("2010-03-14"), Date.parse("2010-11-07")]
DST[2011] = [Date.parse("2011-03-13"), Date.parse("2011-11-06")]
DST[2012] = [Date.parse("2012-03-11"), Date.parse("2012-11-04")]
@nonDSTstates = ["04","15", "60", "72", "78", "79", "71", "66"] #AZ, HI, Virgin Islands, Puerto Rice, Wake Island, America Somoa, Midway Islands, Guam have no DST

def process line
   fl_date = Date.parse(line[4]) 
   year = fl_date.year
   state = line[10]
   offset = @airCodes[state][0]
   origin_state_fips = line[14]
   if fl_date > DST[fl_date.year].first and fl_date < DST[fl_date.year].last and not @nonDSTstates.include?(origin_state_fips)
      offset = airCodes[state][1] 
   end
  
#Here we compute the new times by creating time objects and using the offset above having the object return 
#the proper UTC time. **The variable t holds a time from the input and we split it into 2 groups as required by the time object
# The if statements on the t variable checks if the value is empty, which means it was not reported or there is an issue with the example.
#calcualte scheduled_depart_time
   t = line[16]
   scheduled_depart_time = Time.new(line[0],line[1],line[3],t[0]+t[1], t[2]+t[3], 0, offset).utc.strftime('%H%M') 
#calculate scheduled_arrival_time
   t = line[17]
   if !t.empty?
      scheduled_arrival_time = Time.new(line[0],line[1],line[3],t[0]+t[1], t[2]+t[3], 0, offset).utc.strftime('%H%M') 
   end
#calculate local departure time
   t = line[22]
   if !t.empty?
   dep_time_utc =  Time.new(line[0],line[1],line[3],t[0]+t[1], t[2]+t[3], 0, offset).utc.strftime('%H%M') 
   end
#calculate local arrival time
   t = line[23]
   if !t.empty?
      arr_time_utc = Time.new(line[0],line[1],line[3],t[0]+t[1], t[2]+t[3], 0, offset).utc.strftime('%H%M') 
  end

#put the new UTC times into the line.
  line.insert(28, arr_time_utc)
  line.insert(21, dep_time_utc)
  line.insert(8, scheduled_arrival_time)
  line.insert(7, scheduled_depart_time)

end

output = File.new('output.txt', 'w')

a = File.open('January-2012.tsv')
a.each_line do |line|
  b = line.split(/\t/)[0..-2]
  process b 
  output.puts(b.join('    '))
end
output.close

