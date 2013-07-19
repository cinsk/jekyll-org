#!/usr/bin/env ruby
# encoding: UTF-8

ARGV.each { |arg|
  infile = arg

  body = ""

  File.open(infile, "r:UTF-8") { |f|
    body = f.read
  }

  # org-mode version 8.0.3 generated html is different from that of
  # genereted from previous one.
  #
  # Specifically, in the new version, the block in #+BEGIN_HTML
  # ... #+END_HTML was inserted AFTER the html block of table of
  # context.
  # 
  # below code will handle this.
  m = /^.*\n/.match(body)
  if m and /^ *<div *id *= *"table-of-contents"> *$/.match(m.to_s)
    m = /^--- *$.*^--- *$/m.match(body)
    if m
      newbody = body[m.begin(0)..m.end(0)] + body[0...m.begin(0)] + \
      body[(m.end(0) + 1)..-1]
      body = newbody;
    end
  end

  need_close_section = false;

  # org-mode version 8.0.3 uses div id of "outline-container-sec-*" where
  # previous version uses "outline-container-*"

  body.gsub!(/<\/div>\n+<div +id *= *"outline-container-(sec-)?([0-9]+)" +class *= *"outline-2" *>\n+<h2 +id *= *"(sec-[0-9]+)">(.*?)<\/h2> *\n/) { |m|
    repl = ""

    puts "Processing section #{$2}: #{$4}"
    if $1 != "1"
      repl += "</section>\n"
    else
      repl += "</div>\n"
    end

    repl += "<section id=\"#{$3}\">\n"
    repl += "<div id=\"outline-container-#{$2}\">\n"
    repl += "<div class=\"page-header\">\n"
    repl += "<h1>#{$4}</h1>\n"
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


