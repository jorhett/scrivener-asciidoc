#!/usr/bin/perl -w
use strict;
use FileHandle;
$|=1;

my $SOURCEFILE = $ARGV[0];
my $OUTFILE = $ARGV[1];

open( INPUT, "<${SOURCEFILE}" )
    or die "Unable to read input file: ${SOURCEFILE}\n";

# Read past the start of the preface
my $OUTPUTFH = FileHandle->new( $OUTFILE, 'w' )
    or die "Unable to write to output file: ${OUTFILE}\n";

# Now create a loop that outputs each line
my $iterator = 0;
my $afterword;
while( my $line = <INPUT> ) {
    # Preface, afterword, and appendix use a single bracket to identify
    if( $line =~ /^\[\[Preface\]\](.*)$/i ) {
        print $OUTPUTFH "[preface]\n";
        next;
    }
    elsif( $line =~ /^\[\[Afterword\]\](.*)$/i ) {
        print $OUTPUTFH "[preface]\n";
        print $OUTPUTFH '[role="afterword"]' . "\n";
        next;
    }
    elsif( $line =~ /^\[\[Appendix\]\](.*)$/i ) {
        print $OUTPUTFH "[appendix]\n";
        next;
    }

    # Preface, afterword, and appendix must be second level for Asciidoc
    elsif( $line =~ /^= Preface/ ) {
        print $OUTPUTFH "== Preface\n";
        next;
    }
    elsif( $line =~ /^= Afterword/ ) {
        print $OUTPUTFH "== Afterword\n";
        next;
    }
    elsif( $line =~ /^= Appendix/ ) {
        print $OUTPUTFH "== Appendix\n";
        next;
    }

    # Fix all other titles to make valid link targets
    elsif( $line =~ /^\[\[(\w+[^]]+)\]\](.*)$/ ) {
        # First, fix any IDs that have spaces or non-alpha characters
        my $idlabel = $1;
        my $remainder = $2;
        $idlabel =~ s/\s/_/g;
        $idlabel =~ s/[^\w\-]//g;

        # Either way print out both lines and proceed
        print $OUTPUTFH "[[${idlabel}]]${remainder}\n";
        next;
    }

    print $OUTPUTFH $line;
}

close( INPUT )
    or die;

exit 0;
