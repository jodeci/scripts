#!/usr/bin/ruby

# .bash_profile
# alias cdd='`ruby ~/scripts/switcher.rb`'

basepath = "/Users/jodeci/codebase"

if Dir.pwd =~ /#{basepath}\/.*/
  match = Dir.pwd.sub(basepath, '').split('/')
  cmd = "cd #{basepath}/#{match[1]}"
else
  cmd = "cd #{basepath}"
end

puts cmd
