;;; gzleo.el --- 
;; 
;; Author: liuguangzhao
;; Copyright (C) 2007-2010 liuguangzhao@users.sf.net
;; URL: http://www.qtchina.net http://nullget.sourceforge.net
;; Created: 2009-08-29 17:25:07 +0800
;; Version: $Id: gzleo.el 1159 2014-03-21 05:57:04Z drswinghead $
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (set-default-font "Bitstream Vera Sans Mono-13")
;; ;; 设置中文字体
;; (set-fontset-font "fontset-default"
;;                   'gb18030 '("WenQuanYi Bitmap Song" . "unicode-bmp"))


;; 改进，现在可适用于.c.h文件,and .cc.h，.cpp.hpp
;; 默认是.cpp文件和.h
(defun dd-open-h-cpp (p)
  "open related header file or cpp file"
  (interactive "p")
  (setq wholename (buffer-file-name))
  (setq nameext (file-name-extension wholename))
  (if (or (string= nameext "h")
          (string= nameext "hpp")
          (string= nameext "hh"))
      (
       (lambda ()
         (setq namenew (concat (file-name-sans-extension wholename) ".c"))
         (if (not (file-exists-p namenew))
             (setq namenew (concat (file-name-sans-extension wholename) ".cc"))
           )
         (if (not (file-exists-p namenew))
             (setq namenew (concat (file-name-sans-extension wholename) ".cxx"))
           )
         (if (not (file-exists-p namenew))
             (setq namenew (concat (file-name-sans-extension wholename) ".cpp"))
           )
         (find-file namenew)
         )
       )
    )
  (if (or (string= nameext "cpp") 
          (string= nameext "c") 
          (string= nameext "cc")
          (string= nameext "cxx"))
      (
       (lambda ()
         (setq namenew (concat (file-name-sans-extension wholename) ".hpp"))
         (if (not (file-exists-p namenew))
             (setq namenew (concat (file-name-sans-extension wholename) ".hh"))
           )
         (if (not (file-exists-p namenew))
             (setq namenew (concat (file-name-sans-extension wholename) ".h"))
           )
         (find-file namenew)
         )
       )
    )
  )

;; (global-set-key [(control f7)] (lambda () (interactive) (dd-open-h-cpp 0)))
(global-set-key [(control f6)] (lambda () (interactive) (dd-open-h-cpp 1)))
;; (global-set-key [(control f7)] (lambda () (interactive) (dd-open-h-cpp 0)))
;; (global-set-key [(control f6)] (lambda () (interactive) (dd-open-h-cpp 1)))

;; 关闭所有打开的文件, C-c x
(defun close-all-buffers()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))
(global-set-key "\C-cx" 'close-all-buffers)


;; Hide splash-screen and startup-message
;; (setq inhibit-splash-screen t)
;; (setq inhibit-startup-message t)

;; (defun toggle-full-screen ()
;;   "Toggles full-screen mode for Emacs window on Win32."
;;   (interactive)
;;   (shell-command "emacs_fullscreen.exe"))

(defun toggle-full-screen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
                         (if (equal 'fullboth current-value)
                             (if (boundp 'old-fullscreen) old-fullscreen nil)
                           (progn (setq old-fullscreen current-value)
                                  'fullboth)))))
(defun toggle-bars ()
  "Toggles bars visibility."
  (interactive)
  (menu-bar-mode)
  (tool-bar-mode)
  (scroll-bar-mode))

;; (defun toggle-full-screen-and-bars ()
;;   "Toggles full-screen mode and bars."
;;   (interactive)
;;   (toggle-bars)
;;   (toggle-full-screen))

;; Use F11 to switch between windowed and full-screen modes
;; (global-set-key [f11] 'toggle-full-screen-and-bars)

;; Switch to full-screen mode during startup
;; (toggle-full-screen-and-bars)
;; Make new frames fullscreen by default. Note: this hook doesn't do
;; anything to the initial frame if it's in your .emacs, since that file is
;; read _after_ the initial frame is created.
;; (add-hook 'after-make-frame-functions 'toggle-full-screen)
;; (run-with-idle-timer 0.1 nil 'toggle-full-screen)


(provide 'gzleo)
