#!/usr/bin/ruby
abort "usage: [檔案] [原編碼] [轉檔後編碼]" if ARGV.empty?

source_file = ARGV[0]
source_encoding = ARGV[1]
target_encoding = ARGV[2]

File.open(source_file, encoding: source_encoding) do |input|
  File.open("#{target_encoding}_#{source_file}", "w", encoding: target_encoding) do |output|
    output.write(input.read.encode(target_encoding))
  end
end
