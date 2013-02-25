#!/usr/bin/env ruby
# coding: UTF-8

ARGV.each { |arg|
  infile = arg

  body = ""

  File.open(infile, "r") { |f|
    body = f.read
  }

  need_close_section = false;

  body.gsub!(/<\/div>\n+<div +id *= *"outline-container-([0-9]+)" +class *= *"outline-2" *>\n+<h2 +id *= *"(sec-[0-9]+)">(.*?)<\/h2> *\n/) { |m|
    repl = ""

    puts "Processing section #{$1}: #{$3}"
    if $1 != "1"
      repl += "</section>\n"
    else
      repl += "</div>\n"
    end

    repl += "<section id=\"#{$2}\">\n"
    repl += "<div id=\"outline-container-#{$1}\">\n"
    repl += "<div class=\"page-header\">\n"
    repl += "<h1>#{$3}</h1>\n"
    repl += "</div>\n</div>\n"

    need_close_section = true
    repl
  }

  idx = body.rindex("</div>")
  next if idx == nil
  next if body[idx..-1].strip != "</div>"

  body = body[0...idx]

  body += "\n</section>\n\n" if need_close_section

  File.open(infile, "w") { |f|
    f.write body
  }
}


