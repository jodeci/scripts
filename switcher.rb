#!/usr/bin/ruby

# .bash_profile
# alias cdd='`ruby ~/scripts/switcher.rb`'

basepath = "/Users/jodeci/codebase"
target = ARGV[0]

if target.nil?
  if Dir.pwd =~ /#{basepath}\/.*/
    match = Dir.pwd.sub(basepath, '').split('/')
    cmd = "cd #{basepath}/#{match[1]}"
  else
    cmd = "cd #{basepath}"
  end
else
  cmd = "cd #{basepath}/#{target}"
end

puts cmd
