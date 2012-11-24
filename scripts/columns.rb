# Modules containing column index constants for different stages
# in the transformation process. You should just include a module
# wherever you need it
module Columns 
  module Raw
    COLUMNS = [
      'YEAR','MONTH','DAY','DAY_OF_WEEK','CARRIER',
      'TAIL_NUM','FLIGHT_NUM','ORIGIN_AIRPORT','ORIGIN_FIPS','DEST_AIRPORT',
      'SCHED_DEP_TIME', 'DEP_DELAY','DEP_DELAY_15', 'DEP_DELAY_GROUP', 
      'SCHED_ARR_TIME','ARR_DELAY', 'CANCELLED', 'DIVERTED',
      'SCHED_ELAPSED_TIME','DISTANCE',
    ]
    COLUMNS.each_with_index {|column,index| Raw.const_set(column,index) }
  end
  module Reordered
    COLUMNS = [
      'KEY', 'YEAR','MONTH','DAY','DAY_OF_WEEK',
      'ORIGIN_AIRPORT','ORIGIN_FIPS','DEST_AIRPORT','SCHED_DEP_TIME',
      'SCHED_ARR_TIME','SCHED_ELAPSED_TIME','CARRIER','TAIL_NUM',
      'FLIGHT_NUM','DISTANCE','ARR_DELAY','DEP_DELAY','DEP_DELAY_15',
      'DEP_DELAY_GROUP',
    ]
    COLUMNS.each_with_index {|column,index| Reordered.const_set(column,index) }
  end
  module PrevFlightDelayAdded
    COLUMNS = [
      'YEAR','MONTH','DAY','DAY_OF_WEEK',
      'ORIGIN_AIRPORT','ORIGIN_FIPS','DEST_AIRPORT','SCHED_DEP_TIME',
      'SCHED_ARR_TIME','SCHED_ELAPSED_TIME','CARRIER','DISTANCE',
      'PREV_ARR_DELAY','DEP_DELAY','DEP_DELAY_15','DEP_DELAY_GROUP',
    ]
    COLUMNS.each_with_index {|column,index| PrevFlightDelayAdded.const_set(column,index) }
  end
  module Final
    COLUMNS = [
      'YEAR','MONTH','DAY','DAY_OF_WEEK','ORIGIN_AIRPORT',
      'DEST_AIRPORT','SCHED_DEP_TIME','SCHED_ARR_TIME',
      'SCHED_ELAPSED_TIME','CARRIER','DISTANCE','PREV_ARR_DELAY',
      'DEP_DELAY','DEP_DELAY_15','DEP_DELAY_GROUP',
    ]
    COLUMNS.each_with_index {|column,index| Final.const_set(column,index) }
  end
end
