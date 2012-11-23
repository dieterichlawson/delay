#!/usr/bin/env ruby

require 'wukong'
require 'wukong/streamer/encoding_cleaner'

module ColumnReorderer
  class Mapper < Wukong::Streamer::RecordStreamer
    include Wukong::Streamer::EncodingCleaner
    
    def process *line
      #remove cancelleds and diverteds
      return if line[15].to_i == 1 or line[16].to_i == 1
      result = []
      result << line[0..3] #year through day_of_week
      result << line[7] #origin
      result << line[8] #destination
      result << line[9] #sched_dep_time_local
      result << line[13] #sched_arr_time_local
      #TODO: Transform to UTC
      result << line[17] #sched_elapsed_time
      result << line[4..6] #unique_carrier through fl_num
      result << line[18] #distance
      result << line[14] #arr delay
      result << line[10..12] #dep delay
      yield ["#{line[0]}-#{line[1]}-#{line[2]}-#{line[5]}",result.flatten]
    end
  end
  class Reducer < Wukong::Streamer::ListReducer
    # columns
    SCHED_DEP_TIME = 7
    ORIGIN_AIRPORT = 5 
    DEST_AIRPORT = 6
    TAIL_NUM = 11 
    FLIGHT_NUM = 12
    ARR_DELAY = 14

    def finalize
      values.sort! {|x,y| x[SCHED_DEP_TIME].to_i <=> y[SCHED_DEP_TIME].to_i }
      prev_dest = ''
      prev_arr_delay = 0.00
      values.each_with_index do |flight,index|
        if prev_dest == flight[ORIGIN_AIRPORT]
          flight.insert(ARR_DELAY+1,prev_arr_delay)
        else
          flight.insert(ARR_DELAY+1,"0.00")
        end
        prev_dest = flight[DEST_AIRPORT]
        prev_arr_delay = flight[ARR_DELAY]
        [ARR_DELAY, FLIGHT_NUM, TAIL_NUM, 0].each { |index| flight.delete_at index }
        yield flight
      end
    end
  end
end

Wukong::Script.new(
  ColumnReorderer::Mapper,
  ColumnReorderer::Reducer,
).run
