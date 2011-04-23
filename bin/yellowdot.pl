#!/bin/env perl

use strict;
use warnings;

use GD::Simple;
use Getopt::Long;
use Pod::Usage;

sub required
{
	my ($options, @flags) = @_;
	
	foreach my $flag (@flags)
	{
		pod2usage("'$flag' is a required option") if (!exists $options->{$flag});
	}
}

sub parse_cmdline
{
	my $options = {};	
	GetOptions ($options, "paper=s", "filename=s", "help");
		
	pod2usage(1) if $options->{help};
	required($options, "paper", "filename");
	
	return $options;
}

sub paper_size
{
	my ($paper) = @_;

	my ($max_x, $max_y);

	if (uc($paper) eq "LETTER")
	{
		($max_x, $max_y) = (2550, 3300);
	}
	elsif (uc($paper) eq "A4")
	{
		($max_x, $max_y) = (2480, 3508);
	}
	
	return ($max_x, $max_y);
}

sub generate_image
{
	my ($max_x, $max_y, $density) = @_;
	
	my $image = GD::Simple->new($max_x, $max_y);
	$image->fgcolor('yellow');

	my $dots = $max_x * $max_y * $density;

	for (my $count = 0; $count < $dots; $count++)
	{
		my ($rand_x, $rand_y) = (int(rand()*$max_x), int(rand()*$max_y));
		$image->moveTo($rand_x, $rand_y);
		$image->ellipse(1,1);
	}
	
	return $image;
}

sub main
{
	my $options = parse_cmdline();

	my $density = 0.01;

	my ($max_x, $max_y) = paper_size($options->{paper});
	my $image = generate_image($max_x, $max_y, $density);
	
	open (OUT, ">$options->{filename}");
	print OUT $image->png;
	close (OUT);
}

&main;

1;