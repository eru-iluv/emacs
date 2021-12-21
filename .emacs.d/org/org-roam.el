(use-package org-roam
  :ensure t
  :custom
  (org-roam-v2-ack t)
  (org-roam-directory (file-truename "~/Dropbox/notes/"))
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
       ("C-c n f" . org-roam-node-find)
       ("C-c n g" . org-roam-graph)
       ("C-c n i" . org-roam-node-insert)
       ("C-c n c" . org-roam-capture)
       ;; Dailies
       ("C-c n j" . org-roam-dailies-capture-today))
:config
(org-roam-db-autosync-mode)
;; If using org-roam-protocol
(require 'org-roam-protocol))

(setq org-roam-v2-ack t)
