#!/usr/bin/env ruby
require "fast_stemmer"
require "lemmatizer"
require "stopwords"
require "optimist"
require "set"

opts = Optimist.options do
  banner "usage: #{__FILE__} [options] markdown_file"
  opt :show_stopwords, "Include stop words in output", short: 's', default: false
  opt :output, "Write results to file", short: 'o', type: :string
  opt :repeat_only, "Show only words that occur more than once", short: 'r', default: true
end

abort Optimist.educate unless ARGV.length == 1

# Read input file
file = ARGV.shift
text = File.read(file)

# Normalize curly apostrophes so words like “couldn’t” are tokenized correctly
text.tr!("\u2018\u2019", "'")
# Normalize various curly and angle double quotes so dialogue can be removed
# consistently.  This helps drop text quoted with less common punctuation such
# as «like this».
text.tr!("\u201C\u201D\u201E\u201F\u2033\u2036\u00AB\u00BB", '"')

# Remove stray "'s" fragments that can appear when apostrophes are detached but
# ensure we don't strip possessives like "lucy's"
text.gsub!(/(?<![A-Za-z])'s\b/, '')

# Strip dialogue enclosed in double quotes using a quote-aware scanner.
def strip_dialogue(text)
  inside_dq = false
  result = +''
  text.each_char do |ch|
    if ch == '"'
      inside_dq = !inside_dq
    elsif !inside_dq
      result << ch
    end
  end
  result
end

text = strip_dialogue(text)

# Tokenize words. Allow internal apostrophes but avoid leading ones so we don't
# end up with stray "'s" tokens.
words = text.downcase.scan(/[a-z]+(?:'[a-z]+)*/)

# Use fast-stemmer for full stemming and Lemmatizer for irregular forms
LEMMATIZER = Lemmatizer.new

# Stop words to place at the end. Start with the default list from the
# `stopwords` gem and merge in a few extras requested by the user.  We also
# precompute the stems of these words so they still match after lemmatization
# and stemming.
CUSTOM_STOP_WORDS = %w[this i as that his they did could didn't couldn't]
STOP_WORDS_ORIG = Stopwords::STOP_WORDS.to_set.merge(CUSTOM_STOP_WORDS)
STOP_WORD_STEMS = STOP_WORDS_ORIG.map do |w|
  normalized = w.downcase.gsub(/[\u2018\u2019]/, "'")
  lemma = LEMMATIZER.lemma(normalized)
  Stemmer.stem_word(lemma)
end.to_set

# Count occurrences by stem and original word
counts = Hash.new { |h, k| h[k] = { count: 0, forms: Hash.new(0), order: nil } }
index = 0
words.each do |word|
  # Remove trailing possessive 's so "lucy's" and "lucy" are grouped together
  word = word.sub(/'s$/, '')
  # Normalize irregular forms using the lemmatizer then stem
  lemma = LEMMATIZER.lemma(word)
  root = Stemmer.stem_word(lemma)
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
  if STOP_WORD_STEMS.include?(root)
    stop << entry
  else
    main << entry
  end
end

# Sort by frequency then order of appearance
sorted_main = main.sort_by { |e| [-e[1], e[0]] }
sorted_stop = stop.sort_by { |e| [-e[1], e[0]] }

entries = opts[:show_stopwords] ? (sorted_main + sorted_stop) : sorted_main
entries.select! { |_, total, _| total > 1 } if opts[:repeat_only]

lines = entries.map do |form_list, total, _|
  total > 1 ? "#{form_list} (#{total})" : form_list
end

if opts[:output]
  File.write(opts[:output], lines.join("\n") + "\n")
else
  puts lines
end

