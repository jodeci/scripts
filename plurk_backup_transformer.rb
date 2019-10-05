# !/usr/bin/ruby

# frozen_string_literal: true

require 'json'

# 把噗浪備份檔中被轉成原始 unicode 的 CJK 字元轉回可被正常 search 的字串
# copy 到對應目錄下，自己手動切換比較快 XD
# plurk_type = 'plurks'
# plurk_type = 'responses'

Dir['*.js'].each do |filename|
  holder = "BackupData.#{plurk_type}['#{filename.delete_suffix('.js')}']="
  text = File.open(filename, &:read)

  begin
    content = JSON.parse(text[holder.length...-1])
    new_json = holder + content.to_json + ';'
    File.open(filename, 'w') { |file| file.puts new_json }
  rescue JSON::ParserError
    # FIXME: 若重覆執行會解析失敗，但只是自用小工具就先隨便吧
    puts filename
  end
end
