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
      (setq pos (re-search-forward "^<PRE>" (point-max) t))
      (and (not (null pos))
           (delete-region (point-min) (+ pos 1)))
      (goto-char (point-max))
      (setq pos (re-search-backward "^</PRE>" (point-min) t))
      (and (not (null pos))
           (delete-region pos (point-max)))

      (shell-command-on-region (point-min) (point-max) 
                               "awk ' { printf \"%04d: %s\\n\", NR, $0 }'" buf)
      (and (bufferp buffer)
           (progn (set-buffer buffer)
                  (insert-buffer-substring buf))))))

(setq output-buffer (get-buffer-create "*output*"))

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
    <title>Seong-Kook Shin's home page</title>
    <link rel=\"shortcut icon\" href=\"./img/favicon.ico\"/>
    <link rel=\"stylesheet\" type=\"text/css\" 
      href=\"./default.css\" title=\"default\"></link>
  </head>

  <body>
    <h1>GCC Warning/Error List</h1>

    <p>이 문서는 GCC(Version 3.3 기준)에서 발생할 수 있는 경고(warning) 및 에러(error)
       메시지들을 나열하고, 어떤 경우에 해당하는 메시지가 발생할 수 있는지를 설명합니다.
       저자는 이 글이, C (또는 C++) 언어를 처음 배우는 분들이나, 영어에 서툰 분들에게
       도움이 되기를 바랍니다.</p>

    <p>이 페이지는 Emacs에 의해 자동적으로 만들어 진 것입니다.</p>
")

(setq html-footer "<hr></hr>
<p>If you're looking at a paper snapshot, 
   the latest version is available at 
<a href=\"http://www.cinsk.org/\">here</a>.</p>

<p class=\"footer\">
  Copyright &copy; 2005  
  Seong-Kook Shin.  All rights reserved.
</p>

</body></html>")

(defun write-proc (pathname)
  (let ((source (find-file-noselect pathname))
        (desc "N/A")
        args pos)
    (message (format "Processing %s" (file-name-nondirectory pathname)))
    (save-excursion
      (set-buffer source)
      (and (boundp 'compile-arguments)
           (setq args compile-arguments))
      (and (boundp 'description)
           (setq desc description)))

    (save-excursion
      (set-buffer output-buffer)
      (insert (format "<h2>%s</h2>\n" (file-name-nondirectory pathname)))
      (insert (format "<p>%s</p>\n" desc))

      (insert "<div class=\"source2\"><pre>")
      (eval (append '(call-process "gcc" nil output-buffer t) 
                    (split-string args)))
      (insert "</pre></div>\n")
      (insert "<div class=\"source\"><pre>")
      ;;(message (format "position #1: %d" (point)))
    
      (set-buffer source)
      (goto-char (point-max))
      (setq pos (re-search-backward "^/\\*\\*" (point-min) t))

      (and (not (null pos))
           (htmlize-on-region (point-min) pos output-buffer))

;;    (save-excursion
      (set-buffer output-buffer)
      ;;(message (format "position #2: %d" (point)))
      (insert "</div></pre>\n"))

    (kill-buffer source)))

(save-excursion
  (set-buffer output-buffer)
  (erase-buffer)
  (html-mode)
  (insert html-header))


(enumerate-with-variables "./testsuite" 'write-proc)

(save-excursion
  (set-buffer output-buffer)
  (goto-char (point-max))
  (insert html-footer)
  (setq buffer-file-name "./gcc-error.html")
  (save-buffer)
  (kill-buffer output-buffer))