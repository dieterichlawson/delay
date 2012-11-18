#!/usr/bin/env ruby

require 'wukong'
require 'wukong/streamer/encoding_cleaner'

module ColumnReorderer
  class Mapper < Wukong::Streamer::RecordStreamer
    include Wukong::Streamer::EncodingCleaner
    
    def initialize
      f = open('airport_lookup.csv')
      @utc_offsets = {}
      f.each_line do |line|
        
      end
    end

    def process *line
      result = []
      result << line[0..4] #year through fl_date
      result << line[16] #sched_dep_time_local
      result << line[25] #sched_arr_time_local
      #UTC
      result << line[5..9] #unique_carrier through fl_num
      result << line[10..12] #origin
      result << line[13..15] #dest
      result << line[36] #distance
      result << line[33] #sched_elapsed_time
      result << line[17..22] #dep delay
      result << line[25..29] #arr delay
      result << line[24] #taxi in
      result << line[23] #wheels on
      result << line[30..32] #cancelled through diverted
      result << line[34..35] # elapsed time and air time
      if line[37..41] == []
        result << ["0.00"]*5
      else
        result << line[37..41] # delay numbers
      end
      yield result.flatten
    end
  end
end

Wukong::Script.new(
  ColumnReorderer::Mapper,
  nil
).run
