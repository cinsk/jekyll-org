#!/bin/sh
# -*-tcl-*- \
exec tclsh "$0" ${1+"$@"}

#
# $Id$
#

#
# Images per line on thumbnail mode.
#
set img_per_line 4

#
# Images per page on thumbnail mode.
#
set img_per_page 12

#
# Set verbose mode on/off, affects on command line mode
#
set verbose_mode 1

#
# Thumbnail width.
#
set thumbnail_width 120

#
# Set debug mode
#
set debug_mode 0

package require ncgi

::ncgi::parse

set cwd [::ncgi::value cwd .]

#
# Commands to get the image list
#
set img_list [exec find $cwd -path "*.thumbnails" -prune -o -path "*.xvpics*" -prune -o \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) -print]

if {[info exists env(GATEWAY_INTERFACE)] &&
    [regexp "^CGI/.*" $env(GATEWAY_INTERFACE)]} {
    set cgi_mode 1
} else {
    set cgi_mode 0
}


if {$debug_mode != 0} {
    set table_border 1
} else {
    set table_border 0
}

proc get_thumb_filename {img_file} {
    set dirname [exec dirname $file]
    set filename [exec basename $file]
    if {! [file exists ${dirname}/.thumbnails/${filename}]} {
	return ${dirname}/.thumbnails/${filename}
    }
    return $img_file
}

proc proc_gen_thumbs {} {
    global img_list verbose_mode thumbnail_width

    foreach file $img_list {
	if {[file type $file] != "file"} { continue }

	set dirname [exec dirname $file]
	set filename [exec basename $file]
	if {! [file exists ${dirname}/.thumbnails]} {
	    file mkdir ${dirname}/.thumbnails
	}

	if {! [file exists ${dirname}/.thumbnails/${filename}]} {
	    if {$verbose_mode != 0} { puts "Generating thumbnail for $file..." }
	    exec convert -resize ${thumbnail_width}x10000 $file ${dirname}/.thumbnails/${filename}
	}
    }
}


proc proc_thumbnails {} {
    global img_list img_per_page img_per_line
    global table_border cwd

    set page [::ncgi::value page 1]
    set page_cnt [expr [llength $img_list] / $img_per_page]
    set start [expr ($page - 1) * $img_per_page]
    set end [expr $start + $img_per_page - 1]

    if {[llength $img_list] % $img_per_page != 0} {
	incr page_cnt
    }
    
    proc_header
    # puts "page = $page, start = $start, end = $end<br>"

    puts "<p align=\"center\">Page $page of $page_cnt, Total [llength $img_list] image(s)</p>"

    set img_list [lrange $img_list $start [expr $end]]

    
    puts "<p align=\"center\">"
    if {$page > 1} {
	puts "\[ <a href=\"browse.cgi?mode=thumbnails&cwd=$cwd&page=[expr $page - 1]\">Previous</a> \] "
    } else {
	puts "\[ Previous \] "
    }

    puts "\[ <a href=\"./index.html\">Up</a> \] "

    if {$page < $page_cnt} {
	puts "\[ <a href=\"browse.cgi?mode=thumbnails&cwd=$cwd&page=[expr $page + 1]\">Next</a> \] "
    } else {
	puts "\[ Previous \] "
    }
    puts "</p>"

    set cnt 0
    puts "<!--"
    foreach file $img_list {
	puts $file
    }
    puts "-->"
    foreach file $img_list {
	if {[file type $file] != "file"} { continue }
	set dirname [exec dirname $file]
	set filename [exec basename $file]

	if {$cnt == 0} {
	    puts "<table align=\"center\" border=\"$table_border\" cellspacing=\"4\"><tr>"
	}
	if {[file exists ${dirname}/.thumbnails/${filename}]} {
	    set imgname ${dirname}/.thumbnails/${filename}
	} else {
	    set imgname $file
	}
	puts "<td><a href=\"browse.cgi?mode=slide&cwd=$cwd&page=$page&file=$file\"><img width=\"120\" border=\"0\" src=\"$imgname\"></a>"
	set cnt [expr $cnt + 1]
	if {$cnt == $img_per_line} {
	    puts "<!-- cnt: $cnt, img_per_line: $img_per_line -->"
	    set cnt 0
	    puts "</tr></table>"
	}
    }
    if {$cnt != 0} {
	puts "<!-- cnt: $cnt, img_per_line: $img_per_line -->"
	set cnt 0
	puts "</tr></table>"
    }
    proc_footer
}

proc proc_slide {} {
    global img_list img_per_page img_per_line cwd
    set file [::ncgi::value file]
    set page [::ncgi::value page]
    set index [lsearch $img_list $file]

    if {$index > 0} {
	set prev [lindex $img_list [expr $index - 1]]
    }
    if {$index < [llength $img_list]} {
	set next [lindex $img_list [expr $index + 1]]
    }

    proc_header
    puts "<p align=\"center\">"
    if {[info exists prev]} {
	set page [expr ($index - 1) / $img_per_page]
	puts "\[ <a href=\"browse.cgi?mode=slide&page=$page&cwd=$cwd&file=$prev\">Previous</a> \] "
    }
    puts "\[ <a href=\"browse.cgi?mode=thumbnails&page=$page&cwd=$cwd\">Thumbnails</a> \] "
    
    if {[info exists next]} {
	set page [expr ($index + 1) / $img_per_page]
	puts "\[ <a href=\"browse.cgi?mode=slide&page=$page&cwd=$cwd&file=$next\">Next</a> \] "
    }
    puts "</p>"

    puts "<p align=\"center\"><img src=\"$file\" border=\"1\"></p>"
    puts "<p align=\"center\">[exec identify $file]</p>"
    proc_footer
}

proc proc_header {} {
    puts {<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/TR/xhtml1" xml:lang="en" lang="en">
  <head>
    <!-- $Id$ -->
    <meta http-equiv="charset" content="iso-8859-1"></meta>
    <title>My Humble Photo Browser</title>
    <link rel="stylesheet" type="text/css" 
      href="/~cinsk/css/default.css" title="default"></link>

    <link rel="Start" href="/~cinsk/index.html"></link>
    <link rel="Up" href="/~cinsk/trips/index.html"></link>
    <!-- s<link rel="Prev" href="./profile.html"></link>
    <link rel="Next" href="./books/index.html"></link> -->
  </head>

  <body>
    <h1>My Photo Collection</h1>
    }
}

proc proc_footer {} {
    puts {<hr></hr>
    <p class="footer">
      If you're looking at a paper snapshot, 
      the latest version is available at 
      <a href="http://pcrc.hongik.ac.kr/~cinsk/">here</a>.
      <!-- </p>
      
      <p class="footer"> --> <br></br>
      Copyright &copy; 2004  
      Seong-Kook Shin.  All rights reserved.

      <br></br>

      <p class="footer">
        $Id$
      </p>
    </p>}
}

set mode [::ncgi::value mode "thumbnails"]

#
# command line option parsing..
#

proc help_and_exit {} {
    puts "usage: blah blah blah..."
    exit 0
}

proc version_and_exit {} {
    puts "$argv0 version $version_string"
    exit 0
}

proc query {msg answer_list args} {
    if {[llength $args] > 1} {
	error "wrong # of args: should be query answers ?default?"
    }
}
    

proc syserror {status msg} {
    global argv0
    puts "$argv0: $msg"
    if {$status != 0} {
	if {$cgi_mode == 0} {
	    exit $status 
	} else {
	    exit 0
	}
    }
}

while {[llength $argv] != 0} {
    set first [lindex $argv 0]
    
    if {[string index $first 0] != "-"} { break }

    switch -glob -- $first {
	"-h"	 { help_and_exit }
	"--help" { help_and_exit }
	"-v"	 { version_and_exit }
	"--version" { version_and_exit }
	"--test" { set cgi_mode 1 }
	"--verbose" { set verbose_mode 1 }
	"*"	 { syserror 1 "unknown option \"$first\". try \"-h\" for more." }
    }
    set argv [lrange $argv 1 end]
}	


#
# Main.
#

if {$cgi_mode == 0} {
    proc_gen_thumbs
    exit 0
}

puts "Content-type: text/html"
puts ""


if {[string compare $mode "thumbnails"] == 0} {
    proc_thumbnails
} else {
    proc_slide
}

