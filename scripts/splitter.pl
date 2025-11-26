#!/usr/bin/env perl

# script to split up the full bible off project gutenberg into
# files for each book. kind of a WIP.

open(INFILE, "<", "web.txt");

while(<INFILE>) {
    if ($_ =~ /Book (\d+) ([\w ]+)/) {
        $bname = lc($2);
        $bname =~ s/\W/_/g;
        open(OFILE, ">", "${bname}.txt");
    } else {
        print OFILE;
    }
}
