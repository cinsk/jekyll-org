#!/bin/sh

# $Id$

echo "Content-type: text/html"
echo ""

cat <<EOF
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
  <head>
    <!-- $Id$ -->
    <title>Source of browse.cgi</title>
    <link rel="stylesheet" type="text/css" 
      href="../css/default.css" title="default"></link>

    <link rel="Start" href="../index.html"></link>
    <link rel="Up" href="./index.html"></link>
  </head>
  <body>
    <h1>Source of browse.cgi</h1>
    <p align="right">[ <a href="../index.html">Top</a> ] 
       [ <a href="./index.html">Back</a> ]
    </p>

    <p>
    Save this content to &quot;browse.cgi&quot; and give an 
    executable permission. And there you go~ :-)
    <hr></hr>
    <pre>
EOF

cat browse.cgi | sed -e 's/\&/\&amp;/g' | \
    sed -e 's/</\&lt;/g
s/\"/\&quot;/g
s/>/\&gt;/g'

cat <<EOF
</pre>
    <hr></hr>
    <p class="footer">
      If you're looking at a paper snapshot, 
      the latest version is available at 
      <a href="http://www.cinsk.org/">here</a>.
      <!-- </p>
      
      <p class="footer"> --> <br></br>
      Copyright &copy; 2004  
      Seong-Kook Shin.  All rights reserved.

      <br></br>

      <p class="footer">\$Id$</p>
    </p>
</body>
</html>
EOF
#' This is a work-around to make XEmacs syntax highlighting comfortable.

