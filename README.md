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
a file with `-o`. By default only repeated words are printed; pass
`--no-repeat-only` to show every word:

```bash
./word_counter.rb -s -o results.txt --no-repeat-only sample.md
```

The script strips dialogue enclosed in straight or curly double quotes using a
quote-aware scanner so longer files with uneven quoting are handled correctly.
Trailing possessive `'s` is collapsed so words like `Lucy` and `Lucy's` are
tallied together. Extra stop words like `this`, `i`, `as`, `that`, `his`,
`they`, `did`, `could`, `didn't`, and `couldn't` are merged with the gem's
default list. Their stems are precomputed so conjugated forms such as `did`
(which lemmatizes to `do`) are still matched.
