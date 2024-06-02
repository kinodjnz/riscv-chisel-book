#!/usr/bin/env ruby

require 'optparse'
opt = OptionParser.new

output_file = nil

opt.on('-o VAL') {|v| output_file = v }

opt.parse!(ARGV)

if ARGV.size < 2
  puts "usage: trace_asm.rb trace dump [-o output]"
  exit 1
end

dump = IO.readlines(ARGV[1])

asm_map = Hash.new
dump.each do |line|
  line[0..8].match('([ 0-9A-Fa-f]{8}):') do |m|
    address = "#{$1}".hex
    address = address & ~0x80000000
    asm = line[24..].chomp
    asm_map[address] = asm.gsub(/\t/, ' ')
  end
end

output = STDOUT

if output_file != nil then
  output = File.open(output_file, "w")
end

File.open(ARGV[0]) do |trace_file|
  trace_file.each_line do |line|
    elems = line.split(/\t/, 4)
    if elems[0] == "L" then
      address = elems[3].split(/ /, 2)[0].hex
      address = address & ~0x80000000
      output.puts "#{line.chomp} #{asm_map[address]}"
    else
      output.puts line.chomp
    end
  end
end

if output_file != nil then
  output.close
end
