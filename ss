#!/bin/sh
# simple-static - based on ss, the simplest static website generator possible.

ss_filter() {
  for b in $BL; do
    [ "$b" = "$1" ] && return 0
  done
}

ss_main() {
  $MDHANDLER $1
}

ss_menu() {
  echo "<ul>"
  [ -z "`echo $1 | grep index.md`" ] && echo "<li><a href=\"index.html\">.</a></li>"
  [ "`dirname $1`" != "." ] && echo "<li><a href=\"../index.html\">..</a></li>"
  FILES=`ls \`dirname $1\` | sed -e 's,.md$,.html,g'`
  for i in $FILES ; do
    ss_filter $i && continue
    NAME=`echo $i | sed -e 's/\..*$//' -e 's/_/ /g'`
    [ -z "`echo $i | grep '\..*$'`" ] && i="$i/index.html"
    echo "<li><a href=\"$i\">$NAME</a></li>"
  done
  echo "</ul>"
}

ss_page() {
  # Header
  cat << _header_
<!doctype html>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
  <head>
    <title>${TITLE}</title>
    <!-- <link rel="icon" href="/favicon.png" type="image/png"> -->
    <meta charset="utf-8">
_header_

  # Stylesheet
  ss_style

  cat << _header_
  </head>
  <body>
    <div class="header">
      <h1 class="headerTitle">
        <a href="`echo $1 | sed -e 's,[^/]*/,../,g' -e 's,[^/]*.md$,index.html,g'`">${TITLE}</a> <span class="headerSubtitle">${SUBTITLE}</span>
      </h1>
    </div>
_header_

  # Menu
  echo "<div id=\"side-bar\">"
  ss_menu $1
  echo "</div>"

  # Body
  echo "<div id=\"main\">"
  ss_main $1
  echo "</div>"

  # Footer
  cat << _footer_
  <div id="footer">
    <div class="right"><a href="http://nibble.develsec.org/projects/ss.html">Powered by ss</a></div>
  </div>
  </body>
</html>
_footer_
}

ss_style() {
  if [ -f $CDIR/$STYLE ]; then
    echo '<style type="text/css">'
    cat $CDIR/$STYLE
    echo '</style>'
  fi
}

# Set input dir
IDIR="`echo $1 | sed -e 's,/*$,,'`"
if [ -z "$IDIR" ] || [ ! -d $IDIR ]; then
  echo "Usage: ss [dir]"
  exit 1
fi

# Load config file
if [ ! -f $PWD/ss.conf ]; then
  echo "Cannot find ss.conf in current directory"
  exit 1
fi

. $PWD/ss.conf

# Setup output dir structure
CDIR=$PWD
ODIR="$CDIR/`basename $IDIR`.static"
rm -rf $ODIR
mkdir -p $ODIR
cp -rf $IDIR/* $ODIR
rm -f `find $ODIR -type f -iname '*.md'`

# Parse files
cd $IDIR
FILES=`find . -iname '*.md' | sed -e 's,^\./,,'`
for a in $FILES; do
  b="$ODIR/`echo $a | sed -e 's,.md$,.html,g'`"
  echo "* $a"
  ss_page $a > $b;
done

exit 0
