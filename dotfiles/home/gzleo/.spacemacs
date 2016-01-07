;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(add-to-list 'load-path (expand-file-name "~/.emacs.d/handby/"))
(require 'gzleo)

(set-variable 'ycmd-server-command '("python2" "/usr/share/vim/vimfiles/third_party/ycmd/ycmd/"))
(set-variable 'ycmd-global-config (expand-file-name "~/.emacs.d/handby/ycm_global_extra_conf.py"))
(add-hook 'after-init-hook #'global-ycmd-mode)
(add-hook 'c++-mode-hook 'ycmd-mode)
(add-hook 'cc-mode-hook 'ycmd-mode)
(add-hook 'c-mode-hook 'ycmd-mode)
(add-hook 'python-mode-hook 'ycmd-mode)
(add-hook 'php-mode-hook 'ycmd-mode)
(add-hook 'go-mode-hook 'ycmd-mode)
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
;; (add-hook 'ruby-mode-hook 'ycmd-mode)
;; (add-hook 'enhruby-mode-hook 'ycmd-mode)
;; (add-hook 'enh-ruby-mode-hook 'ycmd-mode)
;; (global-ycmd-mode t)

;; (load "~/.emacs.d/shackle.el")
;; (shackle-mode t)
;; (setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.4)))
(load "~/.emacs.d/handby/duplicate-line.el")
(load "~/.emacs.d/handby/pkgbuild-mode.el")
(global-set-key "\M-p" 'duplicate-previous-line)
(global-set-key "\M-n" 'duplicate-following-line)

;; (require 'protobuf-mode)
(autoload 'protobuf-mode "protobuf-mode" "Protobuf mode." t)
(add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))

;; folding, TODO dynamic load dash and s，少一个折叠指示标识，像小三角形
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/dash-20151216.1315/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/s-20150924.406/"))
(require 'dash)
(require 's)
(require 'origami)
(global-origami-mode t)
(global-set-key (kbd "C--") 'origami-toggle-node)

;;(global-set-key "\C-c @ \C-M-s" 'origami-open-all-nodes)
;;(global-set-key "\C-c @ \C-M-h" 'origami-close-all-nodes)
;; (global-set-key "\C-c @ \C-s" 'origami-open-node)
;; (global-set-key "\C-c @ \C-h" 'origami-close-node)
;;(global-set-key "\C-c @ \C-c" 'origami-toggle-node)

;; for hideshow/hs
;; hs的快捷键太长了，麻烦。
;; C-c @ C-M-s show all
;; C-c @ C-M-h hide all
;; C-c @ C-s show block
;; C-c @ C-h hide block
;; C-c @ C-c toggle hide/show

;; yafolding的问题，光标定位不准确，在括号范围内时。
(require 'yafolding)
;; (yafolding-mode t)

;;; for ecb，不过ecb和spacemacs不兼容。
(setq ecb-display-news-for-upgrade nil)
(setq ecb-tip-of-the-day nil)
(setq stack-trace-on-error t)
(require 'ecb)
;; (setq ecb-compile-window t)
;; (setq ecb-compile-window-height 6)
;; (setq ecb-layout-name "left8")  ;; and left8 is the default
;; (ecb-activate)
;; (run-with-idle-timer 0.618 nil 'ecb-activate)
;; (add-hook 'ecb-deactivate-hook
;; (lambda () (modify-all-frames-parameters '((width . 80)))))

;; (setq helm-completing-read-handlers-alist
   ;;   '((minibuffer-complete . ido)))
;; (setq helm-autoresize-max-height 30)
;; (setq helm-autoresize-min-height 30)

;; (setq helm-split-window-default-side 'above)
;; (setq helm-split-window-default-side 'below)
;; (setq helm-split-window-in-side-p           t)
;; (setq helm-always-two-windows t)

;; UI,Project,Navigitar
(global-set-key [f8] 'neotree-toggle)
(setq projectile-switch-project-action 'neotree-projectile-action)


(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   dotspacemacs-configuration-layers
   '(
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     ;; auto-completion
     ;; better-defaults
     ;; emacs-lisp
     ;; git
     ;; markdown
     ;; org
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     ;; spell-checking
     ;; syntax-checking
     ;; version-control

     auto-completion
     better-defaults
     chinese
     cscope
     emacs-lisp
     git
     markdown
     org
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom)
     syntax-checking
     version-control
     flycheck
     semantic
     color
     c-c++
     python
     php
     go
     ruby
     rust
     html
     javascript
     shell-script
     swift
     sql
     ycmd

     dockerfile
     dash

     gtags
     yaml
     latex ;; 可能导致主界面freeze
     spacemacs-layouts

     (ranger :variables ranger-show-preview t)
     ;; sr-speedbar  ;; 目前还很难用
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages then consider to create a layer, you can also put the
   ;; configuration in `dotspacemacs/config'.
   dotspacemacs-additional-packages '()
   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages '()
   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'. (default t)
   dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; One of `vim', `emacs' or `hybrid'. Evil is always enabled but if the
   ;; variable is `emacs' then the `holy-mode' is enabled at startup. `hybrid'
   ;; uses emacs key bindings for vim's insert mode, but otherwise leaves evil
   ;; unchanged. (default 'vim)
   dotspacemacs-editing-style 'emacs
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in the startup buffer. If nil it is disabled.
   ;; Possible values are: `recents' `bookmarks' `projects'.
   ;; (default '(recents projects))
   dotspacemacs-startup-lists '(recents projects)
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light
                         solarized-light
                         solarized-dark
                         leuven
                         monokai
                         zenburn)
   ;; If non nil the cursor color matches the state color.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 17
                               :weight normal
                               :width normal
                               :powerline-scale 1.2)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m)
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; The command key used for Evil commands (ex-commands) and
   ;; Emacs commands (M-x).
   ;; By default the command key is `:' so ex-commands are executed like in Vim
   ;; with `:' and Emacs commands are executed with `<leader> :'.
   dotspacemacs-command-key ":"
   ;; If non nil `Y' is remapped to `y$'. (default t)
   dotspacemacs-remap-Y-to-y$ t
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f), `find-spacemacs-file' (SPC f e s), and
   ;; `find-contrib-file' (SPC f e c) are replaced. (default nil)
   dotspacemacs-use-ido nil
   ;; If non nil, `helm' will try to miminimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-micro-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup t
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil advises quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init'.  You are free to put any
user code."
  (setq-default
   dotspacemacs-check-for-update nil
   dotspacemacs-elpa-https t
   dotspacemacs-line-numbers t
   dotspacemacs-startup-recent-list-size 10
   dotspacemacs-auto-resume-layouts t
   )
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
 This function is called at the very end of Spacemacs initialization after
layers configuration. You are free to put any user code."
  (progn
    (setq indent-tabs-mode nil)
    (setq default-tab-width 4)
    (setq tab-width 4)
    (setq c-basic-offset 4)
    (setq-default c-basic-offset 4)
    (setq go-indent-level 4)
    (setq php-indent-level 4)
    (setq python-indent-level 4)
    (setq python-indent-offset 4)
    (setq ruby-indent-level 4)
    (setq enh-ruby-indent-level 4)
    (setq js-indent-level 4)
    (setq-default flycheck-flake8-maximum-line-length 100)
    ;; (setq helm-completing-read-handlers-alist
    ;;       '((minibuffer-complete . ido)))
    ;; (setq helm-split-window-default-side 'below)
    ;; (setq helm-split-window-in-side-p           t)
    ;; (setq helm-always-two-windows t)

    ;; (push '("^\*helm.+\*$" :regexp t) popwin:special-display-config)
    ;; (add-hook 'helm-after-initialize-hook (lambda ()
	;; 				    (popwin:display-buffer helm-buffer t)
	;; 				    (popwin-mode -1)))
    ;;  Restore popwin-mode after a Helm session finishes.
    ;; (add-hook 'helm-cleanup-hook (lambda () (popwin-mode 1)))

    ;; (setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.4)))
    )
)

;; spacemacs 0.105两个重要的变化，也是小坑，
;; --insecure
;; dotspacemacs-check-for-update
;; 前者帮助在不通畅的网络环境下下载包，第二个是保证程序安装完成后，不再需要通畅的网络支持。


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-layout-window-sizes
   (quote
    (("left8"
      (ecb-directories-buffer-name 0.16 . 0.2727272727272727)
      (ecb-sources-buffer-name 0.16 . 0.21212121212121213)
      (ecb-methods-buffer-name 0.16 . 0.3333333333333333)
      (ecb-history-buffer-name 0.16 . 0.15151515151515152)))))
 '(ecb-options-version "2.40"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil)))))

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
