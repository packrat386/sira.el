#!/usr/bin/env perl

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
