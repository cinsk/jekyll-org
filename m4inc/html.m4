m4_dnl
m4_dnl A simple m4 script for HTML
m4_dnl
m4_dnl                            Written by <tanarrian@yahoo.co.kr>
m4_dnl
m4_dnl quote character is ``, ''
m4_dnl
m4_dnl k_date - print current date in English locale
m4_dnl k_copyright - tiny footnote for every HTML
m4_dnl k_doctype - print <!DOCTYPE ...>
m4_dnl k_style - print style sheet inclusion
m4_dnl k_meta - print various <META> infomation
m4_dnl k_h[1-6] - h[1-6] tag
m4_dnl k_p   - <p>$@</p>
m4_dnl k_p2  - <p $1>...</p>
m4_dnl k_pc  - <p class=$1>...</p>
m4_dnl k_b   - <strong>...</strong>
m4_dnl k_i   - <em>...</em>
m4_dnl k_t   - <tt>...</tt>
m4_dnl k_pre - <pre>...</pre>
m4_dnl k_div - <div>...</div>
m4_dnl k_lt  - &lt;
m4_dnl k_gt  - &gt;
m4_dnl
m4_changequote(,)m4_changequote(``, '')m4_dnl
m4_dnl
m4_dnl
m4_define(``k_error'', ``m4_errprint(m4___file__:m4___line__:error: $@
)m4_m4exit(1)'')m4_dnl
m4_define(``k_warn'', ``m4_errprint(m4___file__:m4___line__:warning: $@
)'')m4_dnl
m4_dnl
m4_define(``k_date'', ``m4_esyscmd(export LC_ALL=C; echo -n `date`)'')m4_dnl
m4_dnl
m4_dnl
m4_define(``k_toplink'',m4_dnl
``<p>
Return to my [<a href="/~cinsk/">Korean</a>] or
[<a href="/~cinsk/index-en.shtml">English</a>] homepage.
</p>'')m4_dnl
m4_dnl
m4_dnl
m4_define(``k_footer'',m4_dnl
``<hr>
<a href="http://www.gimp.org/"><img src="/~cinsk/images/gimppower.png"
align="right" alt="GIMP powered" border=0></a>
k_toplink
<p>Copyright &copy; 2001  Seong-Kook Shin. All rights reserved.</p>
<p>
Please send comments on these web pages or other questions to
&lt;tanarrian at yahoo dot co dot kr&gt;.
</p>
<p>Updated: k_date</p>
<hr>'')m4_dnl
m4_dnl
m4_define(``k_topfooter'',m4_dnl
``<hr><a href="http://www.gimp.org/"><img src="/~cinsk/images/gimppower.png"
align="right" alt="GIMP powered" border=0></a>
<p>You're <!--#exec cgi="./cgi-bin/counter.cgi"-->th
visitor.</p>
<p>Copyright &copy; 2001  Seong-Kook Shin. All rights reserved.</p>
<p>
Please send comments on these web pages or other questions to
&lt;tanarrian at yahoo dot co dot kr&gt;.
</p>
<p>Updated: k_date</p>
<hr>'')m4_dnl
m4_dnl
m4_define(``k_copyright'', k_footer)m4_dnl
m4_dnl
m4_dnl
m4_define(``k_doctype'', m4_dnl
``m4_ifelse($#, 1,
	``<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
        "http://www.w3.org/TR/html4/$1.dtd">'',
	``k_warn(``k_doctype: no argument provided, default value used'')
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0.1//EN"
	"http://www.w3.org/TR/html4/loose.dtd">'')'')m4_dnl
m4_dnl
m4_dnl
m4_define(``k_meta'', m4_dnl
``<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">'')m4_dnl
m4_define(``k_meta_ch'', m4_dnl
	``m4_ifelse($#, 1,
	``<meta http-equiv="Content-Type" content="text/html; charset=$1">'',
	``k_error(``k_meta_ch(charset) requires one argument'')'')'')m4_dnl
m4_dnl
m4_dnl
m4_define(``k_style'', m4_dnl
	``k_warn(``k_style(css-file) deprecated. use k_style_link(css-file) instead.'')<link rel="stylesheet" href="$1">'')m4_dnl
m4_dnl
m4_define(``k_style_link'', m4_dnl
	``m4_ifelse($#, 1,
	``<link rel="stylesheet" href="$1">'',
	``k_error(``k_style_link(css-file) requires one argument'')'')'')m4_dnl
m4_dnl
m4_define(``k_h1'', ``<h1>$*</h1>'')m4_dnl
m4_define(``k_h2'', ``<h2>$*</h2>'')m4_dnl
m4_define(``k_h3'', ``<h3>$*</h3>'')m4_dnl
m4_define(``k_h4'', ``<h4>$*</h4>'')m4_dnl
m4_define(``k_h5'', ``<h5>$*</h5>'')m4_dnl
m4_define(``k_h6'', ``<h6>$*</h6>'')m4_dnl
m4_define(``k_p'', ``<p>$*</p>'')m4_dnl
m4_define(``k_p2'', ``<p $1>m4_shift($*)</p>'')m4_dnl
m4_define(``k_pc'', ``<p class=$1>m4_shift($*)</p>'')m4_dnl
m4_define(``k_b'', ``<b>$*</b>'')m4_dnl
m4_define(``k_i'', ``<em>$*</em>'')m4_dnl
m4_define(``k_t'', ``<tt>$*</tt>'')m4_dnl
m4_define(``k_pre'', ``<pre>$*</pre>'')m4_dnl
m4_define(``k_div'', ``<div>$*</div>'')m4_dnl
m4_define(``k_lt'', ``&lt;'')m4_dnl
m4_define(``k_gt'', ``&gt;'')m4_dnl
m4_define(``k_addr'', ``<address>$*</address>'')m4_dnl
m4_define(``k_ucon'', k_div(k_p2(align="center",m4_dnl
		<font color="red">k_b(Under Construction)</font>)))m4_dnl
m4_dnl
m4_define(``k_fsizek'', ``m4_esyscmd(export LC_ALL=C;m4_dnl
	fsize -k $1)'')m4_dnl
m4_define(``k_fdate'', ``m4_esyscmd(export LC_ALL=C;m4_dnl
	fdate $1)'')m4_dnl
m4_define(``k_code_begin'', ``<div class="code"><pre>'')m4_dnl
m4_define(``k_code_end'', ``</pre></div>'')m4_dnl
m4_define(``k_code2html_file'', ``k_code_begin
m4_esyscmd(code2html -l $1 -n -H $2)m4_dnl
k_code_end'')m4_dnl
m4_define(``k_code2html_region'', ``m4_esyscmd(code2html -l $1 -H <<EEEOOOFFF
m4_shift($@)
EEEOOOFFF)'')m4_dnl
m4_define(``k_flock'', ``<code>k_code2html_region($@)</code>'')m4_dnl
m4_define(``k_flock_region'', ``<pre>k_code2html_region($@)</pre>'')m4_dnl
m4_define(``k_flock_file'', ``k_code2html_file($@)'')m4_dnl
m4_define(``k_uc'', ``<table align="center" border=1 width="100%" cellpadding=1 cellspacing=0><tr>
<td><center><strong><font color="red">UNDER CONSTRUCTION</font></strong></center><br>$@</td>
</tr></table>'')m4_dnl
m4_define(``k_strexpr'', ``<table border=1 cellpadding=2 cellspacing=0>
<tr><td><strong>$@</strong></td></tr></table>'')m4_dnl
m4_dnl
m4_dnl
m4_dnl
<!-- This page is generated by m4(1) using the m4html package
     Date: k_date -->
