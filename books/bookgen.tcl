#!/bin/sh
# \
exec tclsh "$0" "$@"

# $Id$

proc print_record { list } {
    array set book "$list"

    if {[string length "$book(image)"] == 0} {
        set book(image) "noimage.png"
    }
    
    puts "      <table border=\"0\" class=\"bkinfo\">"
    puts "        <tr>"
    puts "          <td class=\"bkimg\" width=\"130\">"
    puts "            <img border=\"0\" class=\"bkimg\" "
    puts "              src=\"img/$book(image)\"></img>"
    puts "          </td>"
    puts "          <td class=\"bkinfo\" valign=\"top\"><div class=\"bkinfo\""
    puts "            <p class=\"bkinfo\"><strong>Title</strong>: $book(title)</p>"
    puts "            <p class=\"bkinfo\"><strong>Author</strong>: $book(author)</p>"
    puts "            <p class=\"bkinfo\"><strong>Publisher</strong>: $book(publisher)</p>"
    puts "            <p class=\"bkinfo\"><strong>ISBN</strong>: $book(isbn)</p>"
    puts "            <p class=\"bkinfo\"><strong>Description</strong>: $book(description)</p>"
    puts "            </div>"
    puts "          </td></tr>"
    puts "      </table><br></br>"
}

proc is_empty_line { line } {
    return [regexp {^[ \t\v]+$} "$line" ]
}

proc parse_info { line } {
    regexp {^([^[:space:]:]+)[[:space:]]*[:][[:space:]]*[^[:space:]]*$}
}

proc get_line { fid line } {
    upvar 1 $line ln
    global line_number
    
    set ret [gets "$fid" ln]
    incr line_number
    return "$ret"
}

array set bookshelf {}

set s_start_pat {^([^:[:space:]]+):[[:space:]]*(.*)$}
set m_start_pat {^([^:[:space:]]+):[[:space:]]*(.*)[\\]$}
set m_middle_pat {^(.*)[\\]$}
set m_end_pat {^(.*[^\\])$}

foreach filename "$argv" {
    if [catch {open "$filename" r} fid] {
        puts stderr "$fid"
        exit 1
    }
    set line_number 0


    if {[info exists book]} { unset book }
    array set book {}
    set book(title) ""
    set book(author) ""
    set book(isbn) ""
    set book(description) ""
    set book(image) ""
    set book(publisher) ""

    while {[get_line "$fid" line] >= 0} {
        set linelen [string length "$line"]
        if {"$linelen" == 0} {
            continue
        }
        if {[is_empty_line "$line"]} {
            continue
        }
        
        set name ""
        set value ""

        if {[regexp "$m_start_pat" "$line" match n v]} {
            # multi line name=value
            set name "$n"
            set value "$v"
            while {[get_line "$fid" line] >= 0} {
                if {[regexp "$m_middle_pat" "$line" match v]} {
                    set value [concat "$value" "$v"]
                } elseif {[regexp "$m_end_pat" "$line" match v]} {
                    set value [concat "$value" "$v"]
                    break
                } else {
                    puts stderr "$file:$line_number: unexpected pattern encountered"
                }
            }
        } elseif {[regexp "$s_start_pat" "$line" match name value]} {
            # single line name=value
        }
        
        if {[string length "$name"] > 0} {
            set book($name) "$value"
        }
    }
    
    # puts [array get book]
    set bookshelf($filename) [array get book]
    close $fid
}

foreach index [array names bookshelf] {
    # puts $bookshelf($index)
    # array set bk $bookshelf($index)
    #puts [array get book]

    print_record $bookshelf($index)
}
