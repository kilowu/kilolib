;; Emacs configuration file
;; Wei Wu <wayne.wuw@alibaba-inc.com>
;; @2010-2013


;; my external lisp package path
(transient-mark-mode t)
(add-to-list 'load-path "/Users/kilo/.emacs.d/")
(set-language-environment 'UTF-8)
(global-font-lock-mode 1)
; remove startup message
(setq inhibit-startup-message t)
(show-paren-mode t)
(setq show-paren-style 'parentheses)
; use 4 spaces to as tab
(setq-default indent-tabs-mode nil)
;; scroll down with the cursor, move down the buffer one line at a time
(setq scroll-step 1)
; represent the buffer name as title
(setq frame-title-format "Kilo@%f")
(setq column-number-mode t)
(setq line-number-mode t)

;; Cursor settings
; set cursor to a vertical bar
(setq-default cursor-type 'bar)
; disable blinking
(blink-cursor-mode 0)
; highlight the current line
;; (global-hl-line-mode 1)
;; (set-face-background hl-line-face "snow")

;; Backup files can be really anoying, so redirect them to /tmp
(setq backup-directory-alist
       `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; By zhifeng.yang
;; coding standard of the Apsara project
(defconst apsara-c-style
  '((c-basic-offset . 4)
    (c-comment-only-line-offset . 0)
    (c-hanging-braces-alist     . ((substatement-open before after)
                                   (brace-list-open)))
    (c-offsets-alist (statement-block-intro . +)
                     (substatement-open . 0)
                     (inline-open . 0)
                     (substatement-label . 0)
                     (statement-cont . +)
                     (namespace-open . [0]) ;absolute offset 0
                     (namespace-close . [0]) ;absolute offset 0
                     (innamespace . [0])
                     )
    )
  "Apsara C/C++ Programming Style\nThis style is a modification of stroustrup style. ")
(c-add-style "apsara" apsara-c-style)
(setq c-default-style '((c++-mode . "apsara") (c-mode . "apsara") (awk-mode . "awk") (other . "gnu")))
(defun insert-gettersetter-apsara-style (type field)
  "Inserts a C++ class field with apsara project style, and getter/setter methods."
  (interactive "MType: \nMField: ")
  (let ((oldpoint (point))
        (capfield (concat (capitalize (substring field 0 1)) (substring field 1)))
        ;;(capfield field)
        )
    (insert (concat type " Get" capfield "() const\n"
                    "{\n"
                    "    return m" capfield ";\n"
                    "}\n"
                    "void Set" capfield "(" type " " field ")\n"
                    "{\n"
                    "    m" capfield " = " field ";\n"
                    "}\n"
                    ))
    (c-indent-region oldpoint (point) t)
    ))

;; load .h in c++-mode
(setq auto-mode-alist
      (append '(("\\.h$" . c++-mode)) auto-mode-alist))

;; auto-completion
;;(require 'auto-complete-config)
;;(add-to-list 'ac-dictionary-directories "/Users/wuwei/.emacs.d/ac-dict")
;;(ac-config-default)

(add-to-list 'load-path "/usr/share/emacs/site-lisp")
(add-hook 'c-mode-common-hook '(lambda() (require 'xcscope)))
(setq cscope-do-not-update-database t)
(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)

;; org-mode settings
(setq org-log-done 'time)

;; mini-map
(require 'minimap)

