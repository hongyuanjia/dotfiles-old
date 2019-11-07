;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Create a popup rule for R to tell the popup system to ignore R buffers
;; https://github.com/hlissner/doom-emacs/issues/1086
(set-popup-rule! "^\\*R:" :ignore t)

;; Rmd for polymode
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

;; Display R layout in an RStudio pattern
(setq display-buffer-alist
      `(("*R Dired"
        (display-buffer-reuse-window display-buffer-in-side-window)
        (side . right)
        (slot . -1)
        (window-width . 0.33)
        (reusable-frames . nil))
        ("*R"
        (display-buffer-reuse-window display-buffer-at-bottom)
        (window-width . 0.5)
        (reusable-frames . nil))
        ("*Help"
        (display-buffer-reuse-window display-buffer-in-side-window)
        (side . right)
        (slot . 1)
        (window-width . 0.33)
        (reusable-frames . nil))))

(define-key! ess-r-mode-map "<C-return>" 'ess-eval-region-or-function-or-paragraph-and-step)
(define-key! ess-r-mode-map "M--" #'ess-insert-assign)
(define-key! evil-motion-state-map "L" 'evil-end-of-line)
(define-key! evil-motion-state-map "H" 'evil-beginning-of-line)
