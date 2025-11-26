sira.el
---

Emacs utilities for dealing with text from the bible.

## Installing

run `./scripts/release.sh` and then do what it says with the tarball.

## Usage

```
(require 'sira)
sira
(sira--insert-verses "john" 13 34 13 35)
013:034 A new commandment I give to you, that you love one another,
        just like I have loved you; that you also love one another.
013:035 By this everyone will know that you are my disciples, if you
        have love for one another."
nil
```

## Licensing

Text is included that is from the World English Bible (`src/data/*.txt` and `web.txt`). That text is in the public domain. Everything else is covered by `LICENSE`
