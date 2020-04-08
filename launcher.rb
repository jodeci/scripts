#!/usr/bin/ruby

# .bash_profile
# alias md='ruby ~/scripts/launcher.rb --app macdown'
# $ md -n newfile
# $ md file

require "optimist"
require "shellwords"
opts = Optimist::options do
  opt :new, "new file", type: String, short: "n"
  opt :app, "app name", type: String
  opt :path, "path", type: String
end

if opts[:path]
  path = opts[:path]
else
  abort "no path"
end

if opts[:app_given]
  app = "#{path}/#{Shellwords::shellescape(opts[:app])}.app/"
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
