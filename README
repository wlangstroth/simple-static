simple-static
=============

The simplest static site generator I can think of. Great for documentation.
Based on sw (http://nibble.develsec.org/projects/sw.html)


Installation
------------

    $ make install

Or if you want to specify the installation path

    $ make install PREFIX=/usr/local


Configuration
-------------

Copy ss.conf and style.css to your working directory, and edit them to fit your
needs.

A method for converting markdown to html is provided (md2html.awk), but if
you need a more sophisticated markdown processor, you can use something like
sundown (https://github.com/tanoku/sundown). Follow its
installation guide and change MDHANDLER line in your ss.conf file to
sundown, like so:

    MDHANDLER="sundown"


Static web generation
---------------------

From your working directory:

    $ ss site

Where 'site' is the folder where your website is located.
The static version of the website is created under 'site.static'.

For example, if you want to create a site with a subdirectory for projects, you
make an index page 'index.md' under site/, along with a projects/ subdirectory,
which has its own 'index.md', so that the result is a directory tree that looks
like this:

ss.conf
style.css
site/
  index.md
  projects/
    index.md

simple-static will create this:

site.static/
  index.html
  projects/
    index.html


Generate and Upload
-------------------

The whole process can be automated if you create a Makefile like this in your
working directory:

$ cat Makefile
all:
    ss site
    rsync -avz site.static/ foo.org:/path/to/wwwroot/
clean:
    rm -rf site.static


Original Authors
----------------
Nibble <develsec.org>
pancake <nopcode.org>
Andrew Antle
