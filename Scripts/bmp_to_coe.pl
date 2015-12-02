#! /usr/bin/env perl

use strict;
use warnings;

my $in_file			= $ARGV[0];
my $out_file		= "icon.coe";

my $hdr_imgdata_loc	= 0x0A;			# Header location for image data offset

# Open the input file in binary mode
open(my $in_fh, "<", $in_file) or die "*** ERROR: can't open ${in_file}";
binmode $in_fh;

# Get the starting location of the data
my $imgdata_offset;
seek($in_fh, $hdr_imgdata_loc, 0);
print "Offset of header imgdata loc: " . tell($in_fh) . "\n";
read($in_fh, $imgdata_offset, 1);
$imgdata_offset = hex(unpack('H*', $imgdata_offset));
print "Imgdata offset: " . $imgdata_offset . "\n";
seek($in_fh, $imgdata_offset, 0);
print "Offset of imgdata: " . tell($in_fh) . "\n";

# Open the output file in text mode
open(my $out_fh, ">", $out_file) or die "*** ERROR: can't create ${out_file}";

# Write the output file header
print $out_fh "memory_initialization_radix = 16;\n";
print $out_fh "memory_initialization_vector =";

my $pixel;
printf("Cursor: %04X\t", tell($in_fh));
while (read($in_fh, $pixel, 3) != 0) {
	$pixel = hex(unpack('H*', $pixel));
	printf("Pixel data: %06X\n", $pixel);
	if ($pixel == 0xFFFFFF) { print $out_fh "\nF"; }
	elsif ($pixel == 0x241CED) { print $out_fh "\n9"; }
	elsif ($pixel == 0x000000) { print $out_fh "\n0"; }
	printf("Cursor: %04X\t", tell($in_fh));
}
print $out_fh ";";

print "\n";


close($in_fh);
close($out_fh);