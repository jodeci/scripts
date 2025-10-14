#!/usr/bin/ruby

file_name = "#{Time.now.strftime('%Y%m%d')}.sql"
file_path = "~/Dropbox/works/fortuna_backup/"

command1 = "pg_dump fortuna_development -a > #{file_name}"
command2 = "mv #{file_name} #{file_path}"
command3 = "ls -lah #{file_path}"

commands = "#{command1} && #{command2} && #{command3}"

exec commands
