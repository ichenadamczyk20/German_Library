#!/usr/bin/perl

while () {


open(FH, '<', '../__init__') or die $!;

@lines = ();

while (<FH>) {
	push @lines, $_;
}

$index = rand @lines;

$line = @lines[$index];



last;
}
