#!/bin/sh
# simple-static - based on sw
# 
# TODO:
# 1) Move the HTML out of this file

# Blacklist filter (BLACKLIST in the config file)
ss_filter() {
  for b in $BLACKLIST; do
    [ "$b" = "$1" ] && return 0
  done
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
<!DOCTYPE html>
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
    <!--[if lt IE 9]>
    <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
  </head>
  <body>
    <header>
      <h1>
        <a href="`echo $1 | sed -e 's,[^/]*/,../,g' -e 's,[^/]*.md$,index.html,g'`">${TITLE}</a> <span>${SUBTITLE}</span>
      </h1>
_header_

  # Menu
  echo "   <nav>"
  ss_menu $1
  echo "   </nav>"

  echo "  </header>"

  # Body
  echo "<div id=\"main\">"
  $MDHANDLER $1
  echo "</div>"

  # Footer
  cat << _footer_
  <footer>
    <div class="right"><a href="http://github.com/wlangstroth/simple-static">Powered by ss</a></div>
  </footer>
  </body>
</html>
_footer_
}

ss_style() {
  if [ -f $WORKING_DIR/$STYLE ]; then
    echo '<style>'
    cat $WORKING_DIR/$STYLE
    echo '</style>'
  fi
}

# ------------------------------------------------------------------------------
# Moin routine
# ------------------------------------------------------------------------------
INPUT_DIR="`echo $1 | sed -e 's,/*$,,'`"
if [ -z "$INPUT_DIR" ] || [ ! -d $INPUT_DIR ]; then
  echo "Usage: ss [dir]"
  exit 1
fi

# Load config file
if [ ! -f ss.conf ]; then
  echo "Cannot find ss.conf in current directory"
  exit 1
fi

. ss.conf

WORKING_DIR=$PWD
OUTPUT_DIR="$WORKING_DIR/`basename $INPUT_DIR`.static"
rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR
cp -rf $INPUT_DIR/* $OUTPUT_DIR
rm -f `find $OUTPUT_DIR -type f -iname '*.md'`

# Parse and generate
cd $INPUT_DIR
FILES=`find . -iname '*.md' | sed -e 's,^\./,,'`
for a in $FILES; do
  b="$OUTPUT_DIR/`echo $a | sed -e 's,.md$,.html,g'`"
  echo "* $a"
  ss_page $a > $b;
done

exit 0
