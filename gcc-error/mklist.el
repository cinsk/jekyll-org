;;;
;;; $Id$
;;;

;;;
;;; Generate HTML files for all GCC error/waring messages
;;; Copyright (c) 2005  Seong-Kook Shin <cinsky at gmail.com>
;;;

;;;
;;; TODO:
;;;
;;;  1. Saving all buffer before doing anything.
;;;  2. Close any opened buffer which is connected to testsuite/
;;;  3. Highlight the error/warning messages
;;;  4. Generate index from the first message satisfying following form:
;;;       "filename:line-number: (error|warning): ..."
;;;
(defun htmlize-on-region (start end &optional buffer language)
  "HTMLize the region that is in LANGUAGE, put HTML code fragment in
BUFFER.  If BUFFER is nil, htmlize-on-region uses \"*Shell Command Output*\"
to store it.  If LANGUAGE is nil, htmlize-on-region assumes that it is \"c\"."
  (interactive "r")
  (let ((buf (get-buffer-create "*Shell Command Output*"))
        pos)

    (and (null language)
         (setq language "c"))

    (save-excursion
      (set-buffer buf)
      (erase-buffer))

    (save-excursion
      (shell-command-on-region start end
                               (concat "enscript --language=html --color "
                                       "--line-numbers=1 --output=- "
                                       (format "--highlight=%s" language))
                               buf)
      (set-buffer buf)
      (goto-char (point-min))
      (setq pos (re-search-forward "<PRE>" (point-max) t))
      (and (not (null pos))
           (delete-region (point-min) (+ pos 1)))
      (goto-char (point-max))
      (setq pos (re-search-backward "</PRE>" (point-min) t))
      (and (not (null pos))
           (delete-region pos (point-max)))

      (shell-command-on-region (point-min) (point-max) 
                               "awk ' { printf \"%04d: %s\\n\", NR, $0 }'" buf)
      (and (bufferp buffer)
           (progn (set-buffer buffer)
                  (insert-buffer-substring buf))))))

(setq output-buffer (get-buffer-create "*output*"))
(setq gcc-buffer (get-buffer-create "*gcc-output*"))

(defun enumerate-with-variables (dir proc)
  (let ((old-default default-directory)
        (old-exec exec-directory)
        (path (expand-file-name dir)))
    (save-excursion
      (set-buffer output-buffer)
      (setq default-directory path)
      (setq exec-directory path)
      (mapcar proc (file-expand-wildcards "*.c" t))
      (setq default-directory old-default)
      (setq exec-directory old-exec)
      nil)))


(setq html-header
"<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"
    \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">
<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"ko\" lang=\"ko\">
  <head>
    <!-- $Id$ -->
    <meta http-equiv=\"Content-Type\" 
          content=\"text/html; charset=utf-8\"/>
    <title>GCC Warning/Error List</title>
    <link rel=\"shortcut icon\" href=\"http://gcc.gnu.org/favicon.ico\"/>
    <link rel=\"stylesheet\" type=\"text/css\" 
      href=\"./default.css\" title=\"default\"></link>
  </head>

  <body>
      <a href=\"http://www.gnu.org/software/gcc/\"><img
      src=\"./gcc.png\" alt=\"GCC Home\" border=\"0\" align=\"right\">
      </img></a>

    <h1>GCC Warning/Error List</h1>

    <p>
       이 문서는 <a href=\"http://www.gnu.org/software/gcc/\">GCC</a> 
       (GNU Compiler Collection)에서 발생할 수 있는 경고(warning) 및
       에러(error)
       메시지들을 나열하고, 어떤 경우에 해당하는 메시지가 발생할 수 있는지를 설명합니다.
       저자는 이 글이, C (또는 C++) 언어를 처음 배우는 분들이나, 영어에 서툰 분들에게
       도움이 되기를 바랍니다.</p>

    <p>이 페이지는 <a href=\"http://www.gnu.org/software/emacs/\">Emacs</a>에
       의해 자동적으로 만들어 진 것입니다. 최신 소스는 제
       <a href=\"http://www.cinsk.org/viewcvs/public_html/gcc-error/\">CVS
       서버</a>에서 얻을 수 있습니다.  이 문서를 다음과 같은 방식으로 직접 만들기 위해서,
       <a href=\"http://www.gnu.org/software/emacs/\">GNU Emacs</a> 최신 버전과
       <a href=\"http://www.gnu.org/software/enscript/\">GNU enscript</a>가
       필요합니다.</p>

    <div class=\"source\"><pre>
      $ cvs -d :pserver:anonymous@www.cinsk.org:/home/cvsroot login
      Password: <RET>
      $ cvs -d :pserver:anonymous@www.cinsk.org:/home/cvsroot co gcc-error
      ...
      $ cvs -d :pserver:anonymous@www.cinsk.org:/home/cvsroot logout
      $ cd gcc-error
      $ make
      ...
      $ ls -F
      CVS/  Makefile	default.css  gcc-error.html  mklist.el	testsuite/
      $ # read gcc-error.html with your favorite web browser.
    </pre></div>


    <hr></hr>
")

(setq html-footer "<hr/>

<div style=\"float: right\">
  <a href=\"http://www.anybrowser.org/campaign/\">
    <img border=\"0\" src=\"../img/anybrowser.png\"
	 alt=\"Any Browser Campaign\"/></a>
  <a href=\"http://jigsaw.w3.org/css-validator/check/referer\">
    <img border=\"0\"
	 src=\"../img/w3c-css.png\"
	 alt=\"Valid CSS!\" /></a>
  <a href=\"http://validator.w3.org/check?uri=referer\">
    <img src=\"../img/w3c-xhtml.png\" border=\"0\"
	 alt=\"Valid XHTML 1.0!\"/></a>

  <br/>

  <a href=\"http://www.gnu.org/software/emacs/\">
    <img border=\"0\" src=\"../img/emacs-powered.png\"
         alt=\"Emacs Powered\"/></a>
  <a href=\"http://www.gimp.org/\">
    <img border=\"0\" src=\"../img/gimp-powered.png\"
         alt=\"Graphics by GIMP\"/></a>
  <a href=\"http://www.vim.org/\">
    <img border=\"0\" src=\"../img/vim-powered.png\"
         alt=\"Vim Powered\"/></a>
</div>

<p class=\"footer\">
  Automatically generated by mklist.el $Revision$

  <br/>

  The latest version is available at 
  <a href=\"http://www.cinsk.org/\">here</a>.

  <br/>

  Copyright &copy; 2005-2006
  Seong-Kook Shin.  All rights reserved.
</p>

</body></html>")

(defun word-replace (old new)
  (goto-char (point-min))
  (while (re-search-forward old nil t)
    (replace-match new nil nil)))

(defun write-proc (pathname)
  (let ((source (find-file-noselect pathname))
        (desc "N/A")
        args pos error)
    (message (format "Processing %s" (file-name-nondirectory pathname)))
    (save-excursion
      (set-buffer gcc-buffer)
      (erase-buffer))

    (save-excursion
      (set-buffer source)
      (and (boundp 'compile-arguments)
           (setq args compile-arguments))
      (and (boundp 'description)
           (setq desc description))
      (and (boundp 'error-string)
           (setq error error-string)))

    (save-excursion
      (set-buffer output-buffer)
      (insert (format "<h2>%s</h2>\n" (file-name-nondirectory pathname)))
      (insert (format "<p>%s</p>\n" desc))

      
      (if error
          (insert (format "<div class=\"source3\"><pre>TODO: %s</pre></div>"
                          error))
        (progn
          (insert "<div class=\"source2\"><pre>")
          ;;(call-process "pwd" nil output-buffer t)

          (eval (append '(call-process "gcc" nil gcc-buffer t) 
                        (split-string args)))

          (save-excursion
            (set-buffer gcc-buffer)
            (word-replace "&" "&amp;")
            (word-replace "&" "&amp;")
            (word-replace "<" "&lt;")
            (word-replace ">" "&gt;")
            (word-replace "\"" "&quot;"))

          (insert-buffer-substring gcc-buffer)

          (insert "</pre></div>\n")))

      (and (not error)
           (progn 
             (insert "<div class=\"source\"><pre>")
             ;;(message (format "position #1: %d" (point)))
    
             (set-buffer source)
             (goto-char (point-max))
             (setq pos (re-search-backward "^/\\*\\*" (point-min) t))

             (if (null pos)
                 (progn (goto-char (point-min))
                        (setq pos (re-search-forward "^///$" (point-max) t))
                        (and (not (null pos))
                             (htmlize-on-region (point-min) (- pos 3) 
                                                output-buffer)))
               (htmlize-on-region (point-min) pos output-buffer))

             ;;    (save-excursion
             (set-buffer output-buffer)
             ;;(message (format "position #2: %d" (point)))
             (insert "</div></pre>\n"))))

    (kill-buffer source)))

(save-excursion
  (set-buffer output-buffer)
  (erase-buffer)
  (html-mode)
  (insert html-header))


(enumerate-with-variables "./testsuite/" 'write-proc)

(save-excursion
  (set-buffer output-buffer)
  (goto-char (point-max))
  (insert html-footer)
  (setq buffer-file-name "./gcc-error.html")
  (save-buffer)
  (kill-buffer output-buffer))
