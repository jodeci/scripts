# !/usr/bin/ruby

# frozen_string_literal: true

abort 'usage: [字串] ' if ARGV.empty?
string = ARGV[0].dump.to_s.downcase
cmd = "ag #{string} -Q"
exec cmd
