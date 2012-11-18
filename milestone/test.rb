#!/usr/bin/env ruby
require 'configliere'
require 'set'

# Ingests the BTS data set and 'categorizes' the 
# categorical variables. Basically, 'categorize'
# counts the number of different categories in a 
# given column and then replaces all the values
# with numbers so that Matlab can easily digest them

IN_FILE = "in.tsv"
OUT_FILE = "out.tsv"
COLUMNS = [3,4,5]

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
end

categorize(IN_FILE,OUT_FILE,COLUMNS)
