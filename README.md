scrivener-asciidoc
==================

A Scrivener compile format and some scripts to produce AsciiDoc.

## Reason for existing

I used these scripts when working on the Learning MCollective book for O'Reilly Media.
    http://shop.oreilly.com/product/0636920032472.do

My favorite writing tool is Scrivener http://www.literatureandlatte.com/scrivener.php

I created a Scrivener compile format which set up chapter headings correctly with a link 
target above them as recommended. Then I wrote some scripts to process the output from 
Scrivener compile to make AsciiDoc in the flavor that O'Reilly wanted.

## Requirements

* **MacPorts** http://www.macports.org/install.php
* **asciidoc** and **docbook-xml** ports

```
$ sudo port install asciidoc docbook-xml
```

## How to Use

1. Install `AsciiDoc.plist` in `~/Library/Application Support/Scrivener/CompileSettings/`
2. Install the remaining scripts anywhere you want
3. Run process.sh with the name of the Scrivener output file and your intended asciidoc target name  

```
$ /usr/local/scrivener-asciidoc/process.sh MyBook.scrivdoc MyBook.asciidoc
```

## Future Plans

None at this time. O'Reilly is shifting towards HTMLBook format as their standard, and I'm
writing my next book in that format. I don't see using these in the future.

I am however willing to accept suggestions and patches should anyone want to get more
creative than I have been.
