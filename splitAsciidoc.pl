#!/usr/bin/perl -w
use strict;
use FileHandle;

our $SOURCEFILE = $ARGV[0];
print 'Source: ' . $SOURCEFILE . "\n";
our $SUFFIX = '.asciidoc';
our $BASENAME = $SOURCEFILE;
$BASENAME =~ s/${SUFFIX}//;
print 'Base: ' . $BASENAME . "\n";
our $PREFACE = $BASENAME . '-Preface' . $SUFFIX;
our $AFTERWORD = $BASENAME . '-Afterword' . $SUFFIX;
our $APPENDIX = $BASENAME . '-Appendix' . $SUFFIX;
print 'Filename: ' . $PREFACE . "\n";

open( INPUT, "<${SOURCEFILE}" )
    or die "Unable to read sourcefile: ${SOURCEFILE}\n";

# Read past the start of the preface
my $OUTPUTFH = FileHandle->new( $PREFACE, 'w' );
while( my $line = <INPUT> ) {
    print $OUTPUTFH $line;
    if( $line =~ /^== Preface/ ) {
        last;
    }
}

# Now create a loop that outputs each line, starting a new file after each chapter break
my $iterator = 0;
my $skipnext2nd = 0;
my $line;
while( $line = <INPUT> ) {
    if( $line =~ /^\[\[[A-Z][\w\-]+\]\]/ ) {
        # Now see if the next line is the start of a new chapter
        my $nextline = <INPUT>;
        if( $nextline =~ /^= / ) {
            # Change file handles
            $OUTPUTFH = &nextFile( $OUTPUTFH, ++$iterator );
            $skipnext2nd = 1;
        }
        elsif( $nextline =~ /^== / ) {
            if( $skipnext2nd ) {
                $skipnext2nd = 0;
            }
            else {
                # Change file handles
                $OUTPUTFH = &nextFile( $OUTPUTFH, ++$iterator );
            }
        }

        # Either way print out both lines and proceed
        print $OUTPUTFH $line . $nextline;
        next;
    }
    elsif( $line =~ /^\[preface\]$/ ) {
        # Now see if the next line is the afterword
        my $nextline = <INPUT>;
        if( $nextline =~ /^\[role="afterword"\]$/ ) {
            # get out of loop
            $line .= $nextline;
            last;
        }
    }

    print $OUTPUTFH $line;
}
$OUTPUTFH->close();
print 'Filename: ' . $AFTERWORD . "\n";
$OUTPUTFH = FileHandle->new( $AFTERWORD, 'w' );
print $OUTPUTFH $line;

while( my $line = <INPUT> ) {
    if( $line =~ /^\[appendix\]/i ) {
        last;
    }
    print $OUTPUTFH $line;
}
$OUTPUTFH->close();
print 'Filename: ' . $APPENDIX . "\n";
$OUTPUTFH = FileHandle->new( $APPENDIX, 'w' );
print $OUTPUTFH "[appendix]\n";

while( my $line = <INPUT> ) {
    print $OUTPUTFH $line;
}

close( INPUT )
    or die;

exit 0;

sub nextFile() {
    use vars qw( $BASENAME $SUFFIX );
    my $fh = shift;
    my $iterator = shift;

    if( ref( $fh ) eq 'FileHandle' ) {
        $fh->close();
    }

    my $chapternum = sprintf( '%02i', $iterator );
    my $filename = $BASENAME . '-Chapter' . $chapternum . $SUFFIX;  
    print 'Filename: ' . $filename . "\n";

    $fh = FileHandle->new( $filename, 'w' )
        || die;

    return $fh;
}
