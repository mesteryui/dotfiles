(setq user-full-name "Oscar")
(setq inhibit-startup-message t
      use-short-answers t)
  (tool-bar-mode -1)                                            ; Desactivar la barra de herramientas
  (menu-bar-mode -1)                                            ; Desactivar la barra de menús
  (scroll-bar-mode -1)                                          ; Desactivar la barra de desplazamiento visible
  (add-to-list 'default-frame-alist '(fullscreen . maximized))

(set-face-attribute 'default nil
  :font "JetBrains Mono NerdFont"
  :height 100
  :weight 'medium)
(set-face-attribute 'variable-pitch nil
  :font "Ubuntu"
  :height 104
  :weight 'medium)
(set-face-attribute 'fixed-pitch nil
  :font "JetBrains Mono NerdFont"
  :height 100
  :weight 'medium)
;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.
(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
  :slant 'italic)

;; This sets the default font on all graphical frames created after restarting Emacs.
;; Does the same thing as 'set-face-attribute default' above, but emacsclient fonts
;; are not right unless I also add this method of setting the default font.
(add-to-list 'default-frame-alist '(font . "JetBrains Mono NerdFont-10"))

;; Uncomment the following line if line spacing needs adjusting.
(setq-default line-spacing 0.12)

(defun os/open-config ()
  "Abrir configuracion de emacs"
  (interactive)
  (find-file "~/.config/emacs/config.org"))
(global-set-key (kbd "C-x c") 'os/open-config)

(setq calendar-month-name-array
      ["Enero" "Febrero" "Marzo" "Abril" "Mayo" "Junio"
       "Julio"    "Agosto"   "Septiembre" "Octubre" "Noviembre" "Diciembre"])

(setq calendar-day-name-array
      ["Domingo" "Lunes" "Martes" "Miércoles" "Jueves" "Viernes" "Sábado"])

(setq org-icalendar-timezone "Europe/Madrid") ;; timezone
(setq calendar-week-start-day 1) ;; la semana empieza el lunes
(setq european-calendar-style t) ;; estilo europeo

;; Emacs 29?
(unless (>= emacs-major-version 29)
  (error "Emacs Writing Studio requires Emacs version 29 or later"))

;; Ajustes personalizados en un archivo separado y cargar la configuración personalizada
(setq-default custom-file
              (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Establecer archivos de paquetes
(use-package package
  :config
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/"))
  (package-initialize))

;; Gestión de paquetes
(use-package use-package
  :custom
  (use-package-always-ensure t)
  (package-native-compile t)
  (warning-minimum-level :error))

(use-package catppuccin-theme
  :ensure t
  :config
(load-theme 'catppuccin :no-confirm))

(require 'org-tempo)
  (setq-default org-startup-indented t
                org-pretty-entities t
                org-use-sub-superscripts "{}"
                org-hide-emphasis-markers t
                org-startup-with-inline-images t
                org-image-actual-width '(300))
(add-hook 'org-mode-hook 'org-indent-mode)

;; Mostrar marcadores de énfasis ocultos
  (use-package org
     :config
      (setq org-directory "~/org/")
      (setq org-agenda-files '("~/org/agenda.org" "~/org/diario-inbox.org"))
      (setq org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
      :bind
      (("C-c c" . org-capture)
       ("C-c a" . org-agenda)))


    ;; Org Export Settings
    (use-package org
      :custom
      (org-export-with-drawers nil)
      (org-export-with-todo-keywords nil)
      (org-export-with-broken-links t)
      (org-export-with-toc nil)
      (org-export-with-smart-quotes t)
      (org-export-date-timestamp-format "%d %B %Y"))

(use-package org-superstar
     :ensure t
     :config
     (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))

     (setq org-ellipsis "▼")

    ;(setq org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆"))
    (setq org-superstar-item-bullet-alist '((?+ . ?➤) (?- . ?✦))))

(use-package org-appear
  :hook
  (org-mode . org-appear-mode))

  (use-package org
    :custom
    (org-list-allow-alphabetical t))

;; Modernise Org mode interface
(use-package org-modern
  :hook
  (org-mode . global-org-modern-mode)
  :custom
  (org-modern-keyword nil)
  (org-modern-checkbox nil)
  (org-modern-table nil))
  (use-package org-fragtog
  :after org
  :custom
  (org-startup-with-latex-preview t)
  :hook
  (org-mode . org-fragtog-mode)
  :custom
  (org-format-latex-options
   (plist-put org-format-latex-options :scale 2)
   (plist-put org-format-latex-options :foreground 'auto)
   (plist-put org-format-latex-options :background 'auto)))
  (use-package ox-epub
  :demand t)

(use-package ox-latex
                :ensure nil
                :demand t
                :custom
                ;; Multiple LaTeX passes for bibliographies
                (org-latex-pdf-process
                 '("pdflatex -interaction nonstopmode -output-directory %o %f"
                   "bibtex %b"
                   "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
                   "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
                ;; Clean temporary files after export
                (org-latex-logfiles-extensions
                 (quote ("lof" "lot" "tex~" "aux" "idx" "log" "out"
                         "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk"
                         "blg" "brf" "fls" "entoc" "ps" "spl" "bbl"
                         "tex" "bcf"))))

(use-package nerd-icons
  ;; :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  ;; (nerd-icons-font-family "Symbols Nerd Font Mono")

  )
(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))
(use-package nerd-icons-completion
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package doom-modeline
:init (doom-modeline-mode 1)
:custom ((doom-modeline-height 15)))

(use-package vertico
:init
(vertico-mode)
:custom
(vertico-count 13)                    ; Número de candidatos a mostrar
(vertico-resize t)
(vertico-cycle t)
(vertico-sort-function 'vertico-sort-history-alpha))

(use-package consult
:bind (
       ("C-c M-x" . consult-mode-command)
       ;; ("C-c k" . consult-kmacro)
       ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
       ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
       ("M-y" . consult-yank-pop)                ;; orig. yank-pop
       ("M-g o" . consult-outline)               ;; Alternativa: consult-org-heading
       ("M-g i" . consult-imenu)
       ("M-g I" . consult-imenu-multi)
       ("M-s d" . consult-find)                  ;; Alternativa: consult-fd
       ("M-s g" . consult-grep)
       ("C-s" . consult-line)))

(use-package marginalia
      :init
      (marginalia-mode))

(use-package orderless
:custom
(completion-styles '(orderless basic))
(completion-category-defaults nil)
(completion-category-overrides
 '((file (styles partial-completion)))))

(use-package flyspell
    :init
      (setq ispell-silently-savep t
        flyspell-case-fold-duplications t
        flyspell-issue-message-flag nil
        flyspell-default-dictionary "es_ES"
        ispell-program-name "hunspell")   
    :hook (text-mode . flyspell-mode)
    :bind (("M-<f7>" . flyspell-buffer)
           ("<f7>" . flyspell-word)))
(defun pp-switch-dictionary()
  "Switch between Dutch and Australian dictionaries."
  (interactive)
  (let* ((dic ispell-current-dictionary)
         (change (if (string= dic "es_ES") "eo" "es_ES")))
    (ispell-change-dictionary change)
    (message "Dictionary switched from %s to %s" dic change)))

(global-set-key (kbd "C-<f7>") 'pp-switch-dictionary)
  (use-package flyspell-correct
    :after (flyspell)
    :bind (("C-;" . flyspell-auto-correct-previous-word)
           ("<f7>" . flyspell-correct-wrapper)))

(use-package company
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 4)
  (company-selection-wrap-around t)
  :init
  (global-company-mode))

(use-package company-posframe
  :config
  (company-posframe-mode 1))

(defun ews-distraction-free ()
  "Distraction-free writing environment using Olivetti package."
  (interactive)
  (if (equal olivetti-mode nil)
      (progn
        (window-configuration-to-register 1)
        (delete-other-windows)
        (text-scale-set 2)
        (olivetti-mode t))
    (progn
      (if (eq (length (window-list)) 1)
          (jump-to-register 1))
      (olivetti-mode 0)
      (text-scale-set 0))))

(use-package olivetti
  :demand t
  :bind
  (("<f9>" . ews-distraction-free)))

(use-package yasnippet
  :config
  (yas-global-mode 1))
(use-package yasnippet-snippets
  :ensure t)

;; use-package with package.el:
(use-package dashboard
 :ensure t 
 :init
 (setq initial-buffer-choice 'dashboard-open)
 (setq dashboard-set-heading-icons t)
 (setq dashboard-set-file-icons t)
 (setq dashboard-banner-logo-title "Bienvenido a Emacs")
 ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
 (setq dashboard-startup-banner "~/.config/emacs/image.png")  ;; use custom image as banner
 (setq dashboard-center-content nil) ;; set to 't' for centered content
 (setq dashboard-items '((recents . 5)
                         (agenda . 5 )
                         (bookmarks . 3)))
 :custom 
 (dashboard-modify-heading-icons '((recents . "file-text")
                                     (bookmarks . "book")))
 :config
 (dashboard-setup-startup-hook))
      (global-set-key (kbd "<f10>") 'open-dashboard)

    (defun open-dashboard ()
      "Abre el buffer *dashboard* y salta al primer widget."
      (interactive)
      (delete-other-windows)
      ;; Refresca  dashboard buffer
      (if (get-buffer dashboard-buffer-name)
          (kill-buffer dashboard-buffer-name))
      (dashboard-insert-startupify-lists)
      (switch-to-buffer dashboard-buffer-name))

(use-package which-key
  :config
  (which-key-mode))

(use-package i3wm-config-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("/sway/.*config.*/" . i3wm-config-mode))
(add-to-list 'auto-mode-alist '("/sway/config\\'" . i3wm-config-mode)))

(use-package fish-mode
  :ensure t)

(use-package magit
  :bind
  ("C-x g" . magit-status))

(use-package git-gutter
  :defer 0.3
  :delight
  :init (global-git-gutter-mode))

(use-package git-timemachine
  :defer 1
  :delight)

(use-package doc-view
:custom
(doc-view-resolution 300)
(doc-view-mupdf-use-svg t)
(large-file-warning-threshold (* 50 (expt 2 20))))

(use-package nov
:init
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(use-package undo-tree
:init
(global-undo-tree-mode 1)
:custom
(undo-tree-visualizer-timestamps t)
(undo-tree-visualizer-diff t)
(undo-tree-auto-save-history nil))

(use-package autorevert
:ensure nil
:diminish
:hook (after-init . global-auto-revert-mode))

(use-package flycheck
:ensure t
:defer t
:init (global-flycheck-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package vterm
:bind
(:map
 vterm-mode-map
 ("C-y" . vterm-yank)
 ("C-q" . vterm-send-next-key)))
(use-package vterm-toggle)

(use-package calfw
  :config
  (setq cfw:org-overwrite-default-keybinding t)) ;; atajos de teclado de la agenda org-mode
;; (setq cfw:display-calendar-holidays nil) ;; para esconder fiestas calendario emacs

(use-package calfw-org
  :ensure t
  :config
  (setq cfw:org-overwrite-default-keybinding t)
  :bind ([f8] . cfw:open-org-calendar))

(use-package org-caldav
  :bind ([f4] . org-caldav-sync)
  :config
  (setq org-caldav-url "https://cloud.disroot.org/remote.php/dav/calendars/mester")
   (setq org-caldav-calendars
    '((:calendar-id "personal"
                    :files ("~/org/agenda.org")
                    :inbox "~/org/diario-inbox.org")))
    (setq org-caldav-backup-file "~/org/calendario/org-caldav-backup.org")
(setq org-caldav-save-directory "~/org/calendario/")
(setq org-icalendar-alarm-time 1))

(use-package mastodon)
(setq mastodon-instance-url "https://im-in.space"
      mastodon-active-user "@mester@im-in.space")
(setq mastodon-tl--highlight-current-toot 1)

(use-package lsp-mode
:ensure t
:hook (typescript-mode . lsp)
:commands lsp)
(use-package consult-lsp
  :ensure t)

(use-package typescript-mode
:ensure t
:config
(add-to-list 'auto-mode-alist '("\.ts\'" . typescript-mode)))
