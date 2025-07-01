# Scripts

## Setup

These scripts rely on a few Ruby gems. To run `word_counter.rb`, install the
`fast-stemmer`, `lemmatizer`, `stopwords`, and `optimist` gems. The
`stopwords` gem provides a dictionary of common English stop words used by the
script and `optimist` supplies easy option parsing:

```bash
gem install fast-stemmer lemmatizer stopwords optimist
```

## Usage

```bash
./word_counter.rb sample.md
```

You can include stop words in the output with `-s` and redirect the results to
a file with `-o`:

```bash
./word_counter.rb -s -o results.txt sample.md
```

The script removes dialogue enclosed in straight or curly double quotes before
counting words so quoted speech is ignored. Trailing possessive `'s` is
collapsed so words like `Lucy` and `Lucy's` are tallied together. Extra stop
words like `this`, `i`, `as`, `that`, `his`, `they`, `did`, `could`, `didn't`,
and `couldn't` are merged with the gem's default list. Their stems are
precomputed so conjugated forms such as `did` (which lemmatizes to `do`) are
still matched.
