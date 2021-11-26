#!/usr/bin/ruby

# make everything into upcase

source = File.open(ARGV[0])
output = "upcase_#{ARGV[0]}"

File.open(output, "w") do |f|
  f.write source.read.upcase
end
