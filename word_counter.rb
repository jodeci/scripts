#!/usr/bin/env ruby
require "fast_stemmer"

abort "usage: #{__FILE__} [markdown_file]" if ARGV.empty?

# Read input file
file = ARGV[0]
text = File.read(file)

# Normalize curly apostrophes to regular ones so words like “couldn’t”
# are tokenized correctly
text.gsub!(/[\u2018\u2019]/, "'")

# Remove dialogue inside double quotes
text.gsub!(/"[^"]*"/, '')

# Tokenize words (letters and apostrophes only)
words = text.downcase.scan(/[a-z']+/)

# Stop words to place at the end
STOP_WORDS = %w[a an the he she it his her him their they them is am are was were be been being have has had do does did to in on at for and or but if then with by of from this i as that].freeze
# Use fast-stemmer for full stemming

# Count occurrences by stem and original word
counts = Hash.new { |h, k| h[k] = { count: 0, forms: Hash.new(0), order: nil } }
index = 0
words.each do |word|
  root = Stemmer.stem_word(word)
  data = counts[root]
  data[:order] ||= index
  data[:count] += 1
  data[:forms][word] += 1
  index += 1
end

# Separate main words and stop words
main = []
stop = []
counts.each do |root, data|
  forms = data[:forms]
  total = data[:count]
  form_list = forms.keys.join(', ')
  entry = [form_list, total, data[:order]]
  if STOP_WORDS.include?(root)
    stop << entry
  else
    main << entry
  end
end

# Sort by frequency then order of appearance
sorted_main = main.sort_by { |e| [-e[1], e[0]] }
sorted_stop = stop.sort_by { |e| [-e[1], e[0]] }

(sorted_main + sorted_stop).each do |form_list, total, _|
  if total > 1
    puts "#{form_list} (#{total})"
  else
    puts form_list
  end
end

