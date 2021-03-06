;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
	   (format "%.2f seconds"
		   (float-time
		    (time-subtract after-init-time before-init-time)))
	   gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

(org-babel-load-file (expand-file-name "~/.emacs.d/general/general.org"))

(org-babel-load-file (expand-file-name "~/.emacs.d/appearance/appearance.org"))

(org-babel-load-file (expand-file-name "~/.emacs.d/buffers/buffers.org"))

(org-babel-load-file (expand-file-name "~/.emacs.d/org/org-mode.org"))

(org-babel-load-file (expand-file-name "~/.emacs.d/org/org-mode.org"))

(org-babel-load-file (expand-file-name "~/.emacs.d/org/org-roam.org"))

(org-babel-load-file (expand-file-name "~/.emacs.d/latex/latex.org"))

(use-package multi-term :ensure t)
(setq multi-term-program "/bin/bash")
(global-set-key (kbd "C-x t") 'multi-term)

(use-package swiper
  :ensure t
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key "\C-s" 'swiper)))

(use-package try
  :ensure t
  :config
  (progn  (global-set-key (kbd "C-x b") 'ivy-switch-buffer)))
(setq ivy-use-virtual-buffers t)
(setq ivy-display-style 'fancy)

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package yasnippet
  :ensure t
  :hook ((LaTeX-mode . yas-minor-mode)
         (post-self-insert . my/yas-try-expanding-auto-snippets))
  :config
  (setq yas-snippet-dirs '("~/Dropbox/yasnippets"))
  (yas-global-mode 1))
  (use-package warnings
    :config
    (cl-pushnew '(yasnippet backquote-change)
                warning-suppress-types
                :test 'equal))

  (setq yas-triggers-in-field t)

  ;; Function that tries to autoexpand YaSnippets
  ;; The double quoting is NOT a typo!
  (defun my/yas-try-expanding-auto-snippets ()
    (when (and (boundp 'yas-minor-mode) yas-minor-mode)
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand))))

;; CDLatex integration with YaSnippet: Allow cdlatex tab to work inside Yas
;; fields
(use-package cdlatex
  :hook ((cdlatex-tab . yas-expand)
         (cdlatex-tab . cdlatex-in-yas-field))
  :config
  (use-package yasnippet
    :bind (:map yas-keymap
           ("<tab>" . yas-next-field-or-cdlatex)
           ("TAB" . yas-next-field-or-cdlatex))
    :config
    (defun cdlatex-in-yas-field ()
      ;; Check if we're at the end of the Yas field
      (when-let* ((_ (overlayp yas--active-field-overlay))
                  (end (overlay-end yas--active-field-overlay)))
        (if (>= (point) end)
            ;; Call yas-next-field if cdlatex can't expand here
            (let ((s (thing-at-point 'sexp)))
              (unless (and s (assoc (substring-no-properties s)
                                    cdlatex-command-alist-comb))
                (yas-next-field-or-maybe-expand)
                t))
          ;; otherwise expand and jump to the correct location
          (let (cdlatex-tab-hook minp)
            (setq minp
                  (min (save-excursion (cdlatex-tab)
                                       (point))
                       (overlay-end yas--active-field-overlay)))
            (goto-char minp) t))))

    (defun yas-next-field-or-cdlatex ()
      (interactive)
      "Jump to the next Yas field correctly with cdlatex active."
      (if (bound-and-true-p cdlatex-mode)
          (cdlatex-tab)
        (yas-next-field-or-maybe-expand)))))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects/")
    (setq projectile-project-search-path '("~/Projects/"))))
(setq projectile-switch-projects-action #'projectile-dired)

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   t
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x n 1"   . treemacs-delete-other-windows)
        ("C-x n t"   . treemacs)
        ("C-x n B"   . treemacs-bookmark)
        ("C-x n C-t" . treemacs-find-file)
        ("C-x n M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

                                        ;   (use-package treemacs-magit
                                        ;    :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))


(use-package lsp-ivy
  :ensure t
  :after lsp)

(use-package lsp-treemacs
  :ensure t
  :after lsp)
(global-set-key (kbd "C-x C-n") 'lsp-treemacs-symbols)

(use-package lsp-mode
  :commands lsp
  :hook ((fortran-mode f90-mode sh-mode) . lsp)
  :config
  (setq lsp-auto-guess-root t)
  (setq lsp-enable-snippet nil)
  (setq lsp-file-watch-threshold 500000)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-prefer-flymake nil)
  (setq lsp-rust-clippy-preference "on"))

(use-package eglot
  :ensure t)
(add-hook 'LaTeX-mode-hook 'eglot-ensure)

;; function decides whether .h file is C or C++ header, sets C++ by
;; default because there's more chance of there being a .h without a
;; .cc than a .h without a .c (ie. for C++ template files)
(defun ejb/c-c++-header ()
  "Sets either c-mode or c++-mode, whichever is appropriate for
the header, based upon the associated source code file."
  (interactive)
  (let ((c-filename (concat (substring (buffer-file-name) 0 -1) "c")))
    (if (file-exists-p c-filename)
        (c-mode)
      (c++-mode))))
(add-to-list 'auto-mode-alist '("\\.h\\'" . ejb/c-c++-header))

(defun ejb/c-c++-toggle ()
  "Toggles a buffer between c-mode and c++-mode."
  (interactive)
  (cond ((string= major-mode "c-mode")
         (c++-mode))
        ((string= major-mode "c++-mode")
         (c-mode))))

(setq c-basic-offset 4)
(setq c-default-style
      '((java-mode . "java")
        (awk-mode . "awk")
        (other . "k&r")))
(setq c-doc-comment-style
      '((c-mode . javadoc)
        (java-mode . javadoc)
        (pike-mode . autodoc)))

(defconst my-cc-style
  '("cc-mode"
    (c-offsets-alist . ((innamespace . [0])))))

(c-add-style "my-cc-mode" my-cc-style)

(use-package ccls
  :ensure t
  :after lsp-mode
  :hook ((c-mode c++-mode) . lsp))

(use-package clang-format
  :ensure t
  :bind (("C-M-<tab>" . clang-format-region)))

(use-package astyle
  :ensure t
  :when (executable-find "astyle"))

(use-package julia-mode :ensure t)
;; Snail requires vterm
(use-package vterm
  :ensure t
  :config
  (setq vterm-always-compile-module t))

(use-package julia-snail
  :hook (julia-mode . julia-snail-mode))

(use-package lsp-julia
  :hook (julia-mode . (lambda ()
                        (require 'lsp-julia)
                        (lsp)))
  :config
  (setq lsp-julia-default-environment "~/.julia/environments/v1.6"))

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred))

(use-package jedi
  :ensure t
  :init
  (add-hook 'python-mode-hook 'jedi:setup)
  (add-hook 'python-mode-hook 'jedi:ac-setup))

(use-package conda
  :ensure t
  :init
  (setq conda-anaconda-home (expand-file-name "~/anaconda3"))
  (setq conda-env-home-directory (expand-file-name "~/anaconda3/envs")))

(use-package gnuplot-mode
  :ensure t)
(add-to-list 'load-path "~/.emacs.d/gnuplot/gnuplot-mode.el")
(autoload 'gnuplot-mode "gnuplot" "Gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
(setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode)) auto-mode-alist))
(require 'ob-gnuplot)

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    ))

(use-package company
   :ensure t
   :config
   (setq company-idle-delay 0)
   (setq company-minimum-prefix-length 2)
   :init (global-company-mode t))

(use-package company-box
  :ensure t
  :hook (global-company-mode . company-box))


 (use-package company-irony
   :ensure t
   :config
   (add-to-list 'company-backends 'company-irony))

 (use-package irony
   :ensure t
   :config
   (add-hook 'c++-mode-hook 'irony-mode)
   (add-hook 'c-mode-hook 'irony-mode)
   (add-hook 'irony-mode-hook 'irony-cdb-auto-setup-compile-options))

 (use-package irony-eldoc
   :ensure t
   :config
   (add-hook 'irony-mode-hook #'irony-eldoc))

(use-package elcord
  :ensure t
  :config

  (global-set-key (kbd "C-c d") 'elcord-mode)


  (setq elcord-use-major-mode-as-main-icon t)
  (setq elcord-display-buffer-detail 'nil)
  (setq elcord-refresh-rate 2)
  :init)
