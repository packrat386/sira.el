sira.el
---

Emacs utilities for dealing with passages from the bible.

## Installing

run `./scripts/release.sh` and then do what it says with the tarball.

## Usage

`(require 'sira)` at some point so it actually exists. Interactive functions form the "public" API.

`M-x sira-insert-passage` takes in a passage in one of the following forms

 * `"John 3"` - Entirety of chapter 3 of the book of John.
 * `"John 3:16"` - Chapter 3 verse 16 of the book of John.
 * `"John 3:16-21"` - Chapter 3 verses 16 through 21 of the book of John.

```
(require 'sira)
sira
(sira-insert-passage "John 13:34-35")
013:034 A new commandment I give to you, that you love one another,
        just like I have loved you; that you also love one another.
013:035 By this everyone will know that you are my disciples, if you
        have love for one another."
nil
```

`M-x sira-open-passage` does the same as insert but in a new buffer.

`M-x sira-open-book` opens a new buffer with the entire contents of a given book.

## Licensing

Text is included that is from the World English Bible (`src/data/*.txt` and `web.txt`). That text is in the public domain. Everything else is covered by `LICENSE`
