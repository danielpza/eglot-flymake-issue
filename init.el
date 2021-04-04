(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)

(use-package typescript-mode
  :straight t
  :mode "\\.tsx\\'")

(use-package flymake-eslint
  :straight t
  :config
  (add-hook 'typescript-mode-hook (lambda () (flymake-eslint-enable)))
  (add-hook 'js-mode-hook (lambda () (flymake-eslint-enable))))

(use-package eglot
  :straight t
  :hook ((js-mode typescript-mode) . 'eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '((js-mode typescript-mode) . (eglot-deno "deno" "lsp")))

  (defclass eglot-deno (eglot-lsp-server) ()
    :documentation "A custom class for deno lsp.")

  (cl-defmethod eglot-initialization-options ((server eglot-deno))
    "Passes through required deno initialization options"
    (list :enable t
	  :lint t)))
