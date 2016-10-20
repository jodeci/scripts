#!/usr/bin/ruby

require "trollop"
opts = Trollop::options do
  opt :new, "new file", type: String, short: "n"
  opt :app, "app name", type: String
end

if opts[:app_given]
  app = "/Applications/#{opts[:app]}.app/"
else
  abort "no app"
end

if opts[:new_given]
  cmd = "touch #{opts[:new]}; open -a #{app} '#{opts[:new]}'"
else
  cmd = "open -a #{app}"
  cmd << " '#{ARGV[0]}'" if ARGV[0]
end

exec cmd
