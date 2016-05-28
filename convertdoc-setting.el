(require 'convertdoc)

;; convert2htmlではなくconvert2html-libreofficeを使用する場合
(setq convert2html-path "convert2html-libreoffice")

;; ewwではなくw3mで表示させる場合
(require 'w3m)
(setq mew-summary-html-render-func 'w3m-region)

;; "c"で添付ファイルを表示
(define-key mew-summary-mode-map (kbd "c")
  'mew-summary-display-with-convert2html)
