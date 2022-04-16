;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Typas Liao"
      user-mail-address "typascake@gmail.com")

(set-file-template! "\\.tex$" :trigger "__tex" :mode 'latex-mode)
(set-file-template! "/beamer\\.tex$" :trigger "__beamer.tex" :mode 'latex-mode)
(set-file-template! "\\.gitignore$" :trigger "__" :mode 'gitignore-mode)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-light
      doom-themes-enable-italic nil)

;; font settings
(defun init-cjk-fonts ()
  (set-fontset-font t 'unicode
                    (font-spec :family "Noto Sans CJK TC") nil 'prepend)
  ;; (setq face-font-rescale-alist '(("Noto Sans CJK TC" . 1.2)))
  )

(defun init-unicode-fonts ()
  (set-fontset-font t 'unicode
                    (font-spec :family "JuliaMono") nil 'prepend))

(add-hook 'doom-init-ui-hook 'init-cjk-fonts)
(add-hook 'doom-init-ui-hook 'init-unicode-fonts)

(setq doom-font
      (font-spec
       :family "Inconsolata" ;; Fira Code again once stylistic sets supported
       ;; :weight 'semi-light
       :size (cond (IS-MAC 16.0) (IS-LINUX 15.0))
       ;; :otf '(opentype nil (ss01 ss02 ss03 ss05 ss08))
       ))

(setq doom-variable-pitch-font (font-spec :family "Noto Sans CJK TC"))


;; native lazy compilation
(setq native-comp-deferred-compilation t)
;; i just don't want to see warning anymore
(setq native-comp-async-report-warnings-errors nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(when IS-MAC (setq dired-use-ls-dired nil))

;; Treat underscores as word
(add-hook! 'python-mode-hook (modify-syntax-entry ?_ "w"))
(add-hook! 'rustic-mode-hook (modify-syntax-entry ?_ "w"))
(add-hook! 'c++-mode-hook (modify-syntax-entry ?_ "w"))
(add-hook! 'c-mode-hook (modify-syntax-entry ?_ "w"))
(add-hook! 'julia-mode-hook (modify-syntax-entry ?_ "w"))

(add-hook! 'prog-mode-hook #'rainbow-delimiters-mode)

(map! :map evil-normal-state-map
      "q" nil)
(map! :map evil-insert-state-map
      "C-p" nil
      "C-n" nil)
(map! :leader
      "c c" nil
      "c C" nil)
(map! :leader
      :desc "Compile" "c C-c" #'compile
      :desc "Recompile" "c C-r" #'recompile
      :desc "Comment region" "c c" #'comment-region
      :desc "Uncomment region" "c u" #'uncomment-region)

(after! org
  (add-to-list 'org-src-lang-modes '("rust" . rustic))
  (add-to-list 'org-src-lang-modes '("toml" . conf-toml)))

(setq TeX-engine 'xetex)

(setq rustic-lsp-server 'rust-analyzer)
(after! rustic
  (setq lsp-rust-analyzer-cargo-load-out-dirs-from-check t)
  (setq lsp-rust-analyzer-proc-macro-enable t))

(after! projectile
  (add-to-list 'projectile-project-root-files-bottom-up "Cargo.toml"))

(use-package! citre
  :defer t
  :init
  (require 'citre-config)
  (map! :leader
        (:prefix "c"
         :desc "Jump to definition" "j" #'citre-jump
         :desc "Back to reference" "b" #'citre-jump-back
         :desc "Peek definition" "p" #'citre-peek)
        (:prefix "p"
         :desc "Update tags file" "u" #'citre-update-this-tags-file)
        )
  (setq citre-project-root-function #'projectile-project-root)
  (setq citre-default-create-tags-file-location 'package-cache)
  (setq citre-use-project-root-when-creating-tags t)
  (setq citre-prompt-language-for-ctags-command t)
  (setq citre-auto-enable-citre-mode-modes '(prog-mode))

  :config
  (defun company-citre (-command &optional -arg &rest _ignored)
    "Completion backend of Citre.  Execute COMMAND with ARG and IGNORED."
    (interactive (list 'interactive))
    (cl-case -command
      (interactive (company-begin-backend 'company-citre))
      (prefix (and (bound-and-true-p citre-mode)
                   (or (citre-get-symbol) 'stop)))
      (meta (citre-get-property 'signature -arg))
      (annotation (citre-capf--get-annotation -arg))
      (candidates (all-completions -arg (citre-capf--get-collection -arg)))
      (ignore-case (not citre-completion-case-sensitive))))

  (setq company-backends '((company-capf company-citre :with company-yasnippet :separate)))
  (setq +lsp-company-backends
        '(company-yasnippet company-capf company-citre company-files company-dabbrev)))

;; some annoying company settings

(after! company
  (add-to-list 'company-transformers #'delete-dups))
