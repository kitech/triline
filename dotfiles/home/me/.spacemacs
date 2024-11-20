;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(add-to-list 'load-path (expand-file-name "~/.emacs.d/handby/"))
(require 'gzleo)

(setq ycmd-force-semantic-completion nil)
(set-variable 'ycm_server_python_interpreter "/usr/bin/python")
;(set-variable 'ycmd-server-command '("python2" "/home/me/oss/YouCompleteMe/third_party/ycmd/ycmd/"))
;; (set-variable 'ycmd-server-command '("python" "/usr/share/vim/vimfiles/third_party/ycmd/ycmd/"))
;; (set-variable 'ycmd-server-command '("/usr/bin/python2" "/home/me/oss/ycmd/ycmd"))
(set-variable 'ycmd-server-command '("python3" "/home/me/oss/ycmd/ycmd"))
;; (set-variable 'ycmd-server-command '("python3" "/usr/share/ycmd/ycmd"))
(set-variable 'ycmd-global-config (expand-file-name "~/.emacs.d/handby/ycm_global_extra_conf.py"))
;; (add-hook 'after-init-hook #'global-ycmd-mode)
;; (add-hook 'after-init-hook #'neotree-show)
;; (add-hook 'buffer-list-update-hook #'neotree-find) ;; infinite loop
;;(add-hook 'c++-mode-hook 'ycmd-mode)
;;(add-hook 'cc-mode-hook 'ycmd-mode)
;;(add-hook 'c-mode-hook 'ycmd-mode)
(add-hook 'c++-mode-hook '(lambda () (company-mode -1)) 'append)
(add-hook 'cc-mode-hook '(lambda () (company-mode -1)) 'append)
(add-hook 'c-mode-hook '(lambda () (company-mode -1)) 'append)
;;(add-hook 'python-mode-hook 'ycmd-mode)
;; (add-hook 'python-mode-hook 'anaconda-mode)
;;(add-hook 'php-mode-hook 'ycmd-mode)
;;(add-hook 'go-mode-hook 'ycmd-mode) ;; fix two duplicate gocode conflict with company-go
(add-hook 'go-mode-hook (lambda () (company-mode -1)) 'append)
;(add-hook 'go-mode-hook #'flycheck-mode)
;(setq gofmt-show-errors 'buffer)
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
;; (add-hook 'ruby-mode-hook 'ycmd-mode)
;; (add-hook 'enh-ruby-mode-hook 'ycmd-mode)
;; (global-ycmd-mode t)
;; (add-hook 'ruby-mode-hook 'projectile-mode)

;; (load "~/.emacs.d/shackle.el")
;; (shackle-mode t)
;; (setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.4)))
;;(load "~/.emacs.d/handby/duplicate-line.el")
(load "~/.emacs.d/handby/pkgbuild-mode.el")
(global-set-key "\M-p" 'duplicate-previous-line)
(global-set-key "\M-n" 'duplicate-following-line)
;; some custom
;(global-set-key (kbd "C-;") 'comment-line)
(global-set-key (kbd "C-,") 'comment-line)
(global-set-key (kbd "C-u") 'eval-region)
(global-set-key (kbd "<C-tab>") 'switch-to-next-buffer)
(global-set-key (kbd "C-S-<iso-lefttab>") 'switch-to-prev-buffer)
;; (global-set-key (kbd "<backtab>") 'switch-to-prev-buffer)
;; <backtab>=shift+tab


(require 'protobuf-mode)
(defconst my-protobuf-style
  '((c-basic-offset . 4)
    (indent-tabs-mode . nil)))
(add-hook 'protobuf-mode-hook
          (lambda () (c-add-style "my-style" my-protobuf-style t)))
(autoload 'protobuf-mode "protobuf-mode" "Protobuf mode." t)
(add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))
;(load "/usr/lib/python3.5/site-packages/kivy/tools/highlight/kivy-mode.el")
;(add-to-list 'auto-mode-alist '("\\.kv\\'" . kivy-mode))
;(add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))

(autoload 'dart-mode "dart-mode" "Darat mode." t)
(add-to-list 'auto-mode-alist '("\\.dart$" . dart-mode))
(require 'qmake-mode)
(require 'qml-mode)
(add-to-list 'auto-mode-alist '("\\.pr[io]$" . qmake-mode))
(add-to-list 'auto-mode-alist '("\\.qml$" . qml-mode))
(add-to-list 'auto-mode-alist '("\\.g4\\'" . antlr-mode))

;; folding, TODO dynamic load dash and s，少一个折叠指示标识，像小三角形
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/dash-20160820.501/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/s-20160928.636/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/29.4/develop/dash-20240510.1327/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/s-20160928.636/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/29.4/develop/hydra-20220910.1206/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/29.4/develop/lv-20200507.1518/"))
;(require 'dash)
;(require 's)
;(require 'origami)
(require 'v-mode)
;(require 'vlang-mode)
;(global-origami-mode t)
;(global-set-key (kbd "C--") 'origami-toggle-node)
(add-to-list 'auto-mode-alist '("\\.v\\'" . v-mode))
(add-to-list 'auto-mode-alist '("\\.vsh\\'" . v-mode))
;(add-to-list 'auto-mode-alist '("\\.v\\'" . vlang-mode))
(add-hook 'v-mode-hook `company-mode)
          
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
(require 'header2)

;;; for ecb，不过ecb和spacemacs不兼容。
(setq ecb-display-news-for-upgrade nil)
(setq ecb-tip-of-the-day nil)
(setq stack-trace-on-error t)
;(require 'ecb)
;; (setq ecb-compile-window t)
;; (setq ecb-compile-window-height 6)
;; (setq ecb-layout-name "left8")  ;; and left8 is the default
;; (ecb-activate)
;; (run-with-idle-timer 0.618 nil 'ecb-activate)
;; (add-hook 'ecb-deactivate-hook
;; (lambda () (modify-all-frames-parameters '((width . 80)))))

;; UI,Project,Navigitar
;; (global-set-key [f8] 'neotree-toggle)
;; (neotree-show)
;; (neotree-toggle)
;; (neotree-mode)
;; (call-interactively 'neotree-show)
;;(defadvice helm-projectile-find-file (after helm-projectile-find-file activate)
;;  (neotree-dir default-directory))

;; (setq helm-completing-read-handlers-alist
   ;;   '((minibuffer-complete . ido)))
;; (setq helm-autoresize-max-height 30)
;; (setq helm-autoresize-min-height 30)

;; (setq helm-split-window-default-side 'above)
;; (setq helm-split-window-default-side 'below)
;; (setq helm-split-window-in-side-p           t)
;; (setq helm-always-two-windows t)

(setq-default treemacs-no-png-images t)
;;(define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action)
(add-hook 'after-init-hook 'treemacs)
(global-set-key [f9] 'treemacs)
(global-set-key (kbd "M-[") 'helm-imenu)

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   ;; dotspacemacs-distribution 'spacemacs
	dotspacemacs-distribution 'spacemacs-base

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
		;csv
     lua
     systemd
     nginx
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press `SPC f e R' (Vim style) or
     ;; `M-m f e R' (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     helm
     emacs-lisp
     ;; neotree
     treemacs
     ;; org
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     ;; spell-checking
     ;; version-control
     
     auto-completion
     ;; company + gopls 占内存还是太大了，用回 company-go
     ;;company
	  tree-sitter
		lsp ;; ycmd
     ;  better-defaults
     ;chinese
     cscope
     ; cfengine
     emacs-lisp
     ;git
     markdown
     tabs ;; 这个好
     ;org
     ;(shell :variables
      ;      shell-default-height 20
       ;     shell-default-position 'bottom)
     syntax-checking
     version-control
     ;; flycheck
     semantic
     ;; color
     c-c++
     cmake
     python
     php
     (go :variables go-format-before-save nil)
     rust
     html
     ;; typescript ;; a heavy subprocess: node tsserver.js
     javascript
     ;; shell-script
     swift
     ;sql
     elm
     (ruby :variables ruby-enable-enh-ruby-mode t)
     ;crystal
     ;julia
     kotlin
     haskell

     ;; dockerfile
     docker
     dash
     protobuf
     plantuml
    restructuredtext
    restclient
    windows-scripts

     ;nlinum
     imenu-list
     gtags
     toml
     yaml
     ;latex ;; 可能导致主界面freeze
     spacemacs-layouts
		;extra-langs
		;QML

     (ranger :variables ranger-show-preview t)
     ;; sr-speedbar  ;; 目前还很难用
     games

     ;; private layers

     )

   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   ;; To use a local version of a package, use the `:location' property:
   ;; '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '()

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default nil)
   dotspacemacs-verify-spacelpa-archives nil

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'emacs

   ;; If non-nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `vim-powerline' and `vanilla'. The first three
   ;; are spaceline themes. `vanilla' is default Emacs mode-line. `custom' is a
   ;; user defined themes, refer to the DOCUMENTATION.org for more info on how
   ;; to create your own spaceline theme. Value can be a symbol or list with\
   ;; additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 13
                               :weight normal
                               :width normal)
   dotspacemacs-default-font '("Source Code Pro"
                               :size 18
                               :weight normal
                               :width normal
                               :powerline-scale 1.0)

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; If non-nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ nil

   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t

   ;; If non-nil, `J' and `K' move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil

   ;; If non-nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil

   ;; if non-nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil

   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom

   ;; Controls fuzzy matching in helm. If set to `always', force fuzzy matching
   ;; in all non-asynchronous sources. If set to `source', preserve individual
   ;; source settings. Else, disable fuzzy matching in all sources.
   ;; (default 'always)
   dotspacemacs-helm-use-fuzzy 'always

   ;; If non-nil, the paste transient-state is enabled. While enabled, pressing
   ;; `p' several times cycles through the elements in the `kill-ring'.
   ;; (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t' or `relative' line numbers are turned on in all `prog-mode' and
   ;; `text-mode' derivatives. If set to `relative', line numbers are relative.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   dotspacemacs-enable-server t

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."

;; http(ok), https(timeout???)
(setq configuration-layer-elpa-archives
	'(("melpa-cn" . "https://mirrors.nju.edu.cn/elpa/melpa/")
		("org-cn" . "https://mirrors.nju.edu.cn/elpa/org/")
		("gnu-cn" . "https://mirrors.nju.edu.cn/elpa/gnu/")))
	;'(("melpa-cn" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
	;	("org-cn" . "https://mirrors.ustc.edu.cn/elpa/org/")
	;	("gnu-cn" . "https://mirrors.ustc.edu.cn/elpa/gnu/")))
	; 垃圾 tuna 动不动就403
    ;'(("melpa-cn" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
    ;  ("org-cn"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
    ;  ("gnu-cn"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))

     (setq-default
     dotspacemacs-check-for-update nil
     dotspacemacs-elpa-https t
     dotspacemacs-line-numbers t
     dotspacemacs-startup-recent-list-size 10
     dotspacemacs-auto-resume-layouts t

     )
)


(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  (progn
    (setq history-length 100)
    ;;(put 'minibuffer-history 'history-length 50)
    ;;(put 'evil-ex-history 'history-length 50)
    ;;(put 'kill-ring 'history-length 25)
    (setq indent-tabs-mode nil)
    (setq default-tab-width 4)
    (setq tab-width 4)
    (setq c-basic-offset 4)
    (setq-default c-basic-offset 4)
    (setq-default flycheck-global-modes nil) ;; case go's flycheck will run 'go build', use too much memory for big project.
    (setq go-indent-level 4)
    (setq go-tab-width 4)
    (setq go-format-before-save t)
    (setq gofmt-command "goimports")
    (setq php-indent-level 4)
    (setq python-indent-level 4)
    (setq python-indent-offset 4)
    (setq python-indent 4)
    (setq nim-indent-level 4)
    (setq nim-indent-offset 4)
    (setq nim-indent 4)
    (setq ruby-indent-level 4)
    (setq enh-ruby-indent-level 4)
    (setq js-indent-level 4)
    (setq crystal-indent-level 4)
    (setq dart-indent-level 4)
    (setq-default flycheck-flake8-maximum-line-length 100)
    ;; (setq projectile-switch-project-action 'neotree-projectile-action)
    (setq-default treemacs-use-follow-mode t)
    (setq-default treemacs-width 25)
    (setq-default treemacs-use-git-mode 'simple)
    (setq-default treemacs-no-png-images t)
    (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action)
    ;;(treemacs)
    ;;(setq neo-show-hidden-files t)
    ;;(setq neo-smart-open t)
    ;;(setq neo-window-width 25) ;; it's defualt
    ;;(neotree-show)
    ;; (set
    ;; (se
    ;;       '((minibuffer-complete . ido)))
    ;; (set
    ;; (set
    ;; (set

    ;; (push '("^\*helm.+\*$" :regexp t) popwin:special-display-config)
    ;; (add-hook 'helm-after-initialize-hook (lambda ()
	;; 				    (popwin:display-buffer helm-buffer t)
	;; 				    (popwin-mode -1)))
    ;;  Restore popwin-mode after a Helm session finishes.
    ;; (add-hook 'helm-cleanup-hook (lambda () (popwin-mode 1)))

	(menu-bar-mode t)
	(scroll-bar-mode t)
	(desktop-save-mode t) ; save/read session
	(size-indication-mode t)
	;; ctrl + Mouse-1 = goto define
    ;; (set
    )
    
  )
  
  ;; spacemacs 0.105两个重要的变化，也是小坑，
;; --insecure
;; dotspacemacs-check-for-update
;; 前者帮助在不通畅的网络环境下下载包，第二个是保证程序安装完成后，不再需要通畅的网络支持。

;; Do not write anything past this comment. This is where Emacs will
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ansi package-build shut-up epl git commander f dash s csv-mode counsel-gtags company-lua lua-mode nim-mode flycheck-nimsuggest commenter flycheck-nim zeal-at-point yasnippet-snippets yapfify yaml-mode xterm-color ws-butler writeroom-mode winum which-key web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package unfill typit treemacs-projectile toml-mode toc-org tagedit systemd symon swift-mode sudoku string-inflection stickyfunc-enhance srefactor spaceline-all-the-icons smeargle slim-mode shell-pop seeing-is-believing scss-mode sass-mode rvm ruby-tools ruby-test-mode ruby-refactor ruby-hash-syntax rubocop rspec-mode robe restclient-helm restart-emacs rbenv ranger rake rainbow-delimiters racer pytest pyenv-mode py-isort pug-mode protobuf-mode prettier-js powershell popwin play-crystal plantuml-mode pippel pipenv pip-requirements phpunit phpcbf php-extras php-auto-yasnippets persp-mode password-generator paradox pangu-spacing pacmacs overseer org-projectile org-present org-pomodoro org-mime org-download org-bullets org-brain open-junk-file ob-restclient ob-http ob-crystal ob-cfengine3 nginx-mode nameless mwim multi-term move-text mmm-mode minitest markdown-toc magit-svn magit-gitflow macrostep lsp-ui lsp-rust lsp-python lsp-julia lsp-javascript-typescript lsp-go lorem-ipsum livid-mode live-py-mode link-hint kotlin-mode julia-repl julia-mode json-navigator js2-refactor js-doc inf-crystal indent-guide importmagic impatient-mode hungry-delete hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers highlight-indentation helm-xref helm-themes helm-swoop helm-rtags helm-pydoc helm-purpose helm-projectile helm-org-rifle helm-mode-manager helm-make helm-hoogle helm-gtags helm-gitignore helm-git-grep helm-flx helm-descbinds helm-dash helm-ctest helm-css-scss helm-cscope helm-company helm-c-yasnippet helm-ag haskell-snippets google-translate google-c-style golden-ratio godoctor go-tag go-rename go-impl go-guru go-gen-test go-fill-struct go-eldoc gnuplot gitignore-templates gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe git-gutter-fringe+ gh-md ggtags fuzzy font-lock+ flycheck-rust flycheck-rtags flycheck-pos-tip flycheck-kotlin flycheck-haskell flycheck-elm flycheck-crystal flx-ido find-by-pinyin-dired fill-column-indicator fancy-battery eyebrowse expand-region evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-org evil-numbers evil-nerd-commenter evil-matchit evil-magit evil-lisp-state evil-lion evil-indent-plus evil-iedit-state evil-goggles evil-exchange evil-escape evil-ediff evil-cleverparens evil-args evil-anzu eval-sexp-fu eshell-z eshell-prompt-extras esh-help enh-ruby-mode emmet-mode elm-test-runner elm-mode elisp-slime-nav editorconfig dumb-jump drupal-mode dotenv-mode doom-modeline dockerfile-mode docker disaster diminish diff-hl define-word cython-mode cquery counsel-projectile company-web company-tern company-statistics company-rtags company-restclient company-php company-lsp company-go company-ghci company-cabal company-c-headers company-anaconda column-enforce-mode cmm-mode cmake-mode cmake-ide clean-aindent-mode clang-format chruby chinese-conv centered-cursor-mode ccls cargo bundler browse-at-remote auto-yasnippet auto-highlight-symbol auto-complete-rst auto-compile ameba aggressive-indent ace-pinyin ace-link ace-jump-helm-line ac-ispell 2048-game))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)
