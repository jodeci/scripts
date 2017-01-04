#!/usr/bin/ruby

# .bash_profile
# alias md='ruby ~/scripts/launcher.rb --app macdown'
# $ md -n newfile
# $ md file

require "trollop"
require "shellwords"
opts = Trollop::options do
  opt :new, "new file", type: String, short: "n"
  opt :app, "app name", type: String
end

if opts[:app_given]
  app = "/Applications/#{Shellwords::shellescape(opts[:app])}.app/"
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
