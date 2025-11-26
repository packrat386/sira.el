#!/usr/bin/env perl

# script to split up the full World English Bible off of Project
# Gutenberg into files for each book.

use feature qw(say);

system("curl -s -o web.txt https://www.gutenberg.org/cache/epub/8294/pg8294.txt") == 0 || die;

say "downloaded web.txt";

open(INFILE, "<", "web.txt");

say "discarding";
open(OFILE, ">", "/dev/null");

while(<INFILE>) {
    s/\r?\n\z/\n/; # CRLF -> LF

    if ($_ =~ /Book (\d+) ([\w ]+)/) {
        $bname = lc($2);
        $bname =~ s/\W/_/g;
        say "writing to: src/data/${bname}.txt";
        open(OFILE, ">", "src/data/${bname}.txt");
    } elsif ($_ =~ /^\s*$/) {
        say "discarding";
        open(OFILE, ">", "/dev/null");
    } else {
        print OFILE;
    }
}
