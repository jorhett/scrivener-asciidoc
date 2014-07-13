#!/bin/bash
CWD=$(dirname $0)
SCRIVENEROUT=$1
ASCIIDOC=$2

# Do some manipulation to make Scrivener output good asciidoc
${CWD}/fixChapterIDs.pl $SCRIVENEROUT $ASCIIDOC
asciidoc -d book $ASCIIDOC
status=$?
if [ $status -ne 0 ]; then
    echo "Last status was $status"
    exit $status
fi 

# Split the asciidoc into chapters
${CWD}/splitAsciidoc.pl $ASCIIDOC
splitstatus=$?
if [ $splitstatus -ne 0 ]; then
    echo "Last status was $splitstatus"
    exit $splitstatus
fi 

# Create a local docbook copy for reference when debugging build problems
a2x -f docbook -d book -L $ASCIIDOC
