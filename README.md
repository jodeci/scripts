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

You can include stop words in the output with `-s` and redirect results to a
file with `-o`. By default only repeated words are printed; pass
`--no-repeat-only` to show every word:

```bash
./word_counter.rb -s -o results.txt --no-repeat-only sample.md
```

To keep particular stop words instead of filtering them, create a
`word_counter.yml` file next to the script and list them under
`keep_stop_words`:

```yaml
keep_stop_words:
  - still
```

The script loads this configuration automatically if the file exists.

 The script strips dialogue before counting words. It first removes text
 enclosed in curly double quotes (`“...”`) and then runs a quote-aware scanner
 to drop any remaining straight or angle double quoted passages. See
 `sample_quotes.md` for examples including single-quoted, angle-quoted, and
 curly-quoted dialogue.
Trailing possessive `'s` is collapsed so words like `Lucy` and `Lucy's` are
tallied together. Extra stop words like `this`, `i`, `as`, `that`, `his`,
`they`, `did`, `could`, `didn't`, and `couldn't` are merged with the gem's
default list. Their stems are precomputed so conjugated forms such as `did`
(which lemmatizes to `do`) are still matched. List any stop words you want to
keep under `keep_stop_words` in `word_counter.yml`.
