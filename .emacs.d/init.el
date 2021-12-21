(setq frame-inhibit-implied-resize t)
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

`use-package'
(unless(package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


(require 'use-package)
(setq use-package-always-ensure t)

(defconst banner-title "E M A C S")



(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

(put 'dired-find-alternate-file 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files nil)
 '(package-selected-packages
   '(conda elcord irony-eldoc company-irony company-box gnuplot-mode astyle clang-format ccls auctex-latexmk which-key websocket use-package try treemacs-projectile treemacs-persp treemacs-icons-dired treemacs-evil swiper spacemacs-theme smartparens simple-httpd rainbow-delimiters python-mode org-roam org-fragtog org-bullets no-littering multi-term magit lsp-treemacs lsp-julia lsp-ivy julia-snail jedi helm-projectile flycheck elpy eglot doom-themes doom-modeline dired-open dired-hide-dotfiles default-text-scale dashboard cdlatex auto-package-update auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 2.0)))))
