(defvar convert2html-path "convert2html")
(defvar mew-summary-html-render-func 'shr-render-region)

(require 'mew)
(require 'noflet)
(require 'f)

(defun mew-summary-display-with-convert2html ()
  "Mewの添付ファイルを外部プログラムでhtml形式に変換してMew内で表示するための関数"
  (interactive)
  (let ((saved-file)
        (attach-file))
    ;; ファイル名を指定して強引に保存！
    (noflet ((mew-summary-input-file-name
              (&optional prompt file)
              (prog1
                  (setq saved-file (concat temporary-file-directory
                                           ;; ファイル名が指定されていないときに
                                           (or file "tmp")))
                (ignore-errors (delete-file saved-file)))))
      (mew-summary-save nil))
    ;; 空白を含むファイル名を外部プログラムが処理できないため、
    ;; ファイルのbasenameを半角英字およびアンダーバーのみに変更
    (setq attach-file
          (myfunc-rename-basename-of-file saved-file "convertdoc_attach"))
    ;; 外部プログラムを起動 => mew-message-last-bufferにhtml形式で出力
    (shell-command (format "%s %s" convert2html-path
                           (shell-quote-argument attach-file))
                   mew-message-last-buffer)
    (mew-summary-render-buffer-as-html mew-message-last-buffer)
    (delete-file attach-file)))


(defun myfunc-retuen-string-changed-basename-of-file (old new)
  "ファイルのbasenameを変更し、フルパスの文字列として返す関数"
  (format "%s%s.%s" (f-slash (f-dirname old)) new (f-ext old)))


(defun myfunc-rename-basename-of-file (file basename)
  "ファイルのbasenameを変更する関数"
  (let ((attach-file))
    (prog1
        (setq attach-file
              (myfunc-retuen-string-changed-basename-of-file file basename))
      (ignore-errors (delete-file attach-file))
      (rename-file file attach-file))))


(defun mew-summary-render-buffer-as-html (buf)
  "引数で指定したバッファの内容を、
mew-summary-html-render-func変数で指定したレンダリング関数によって
HTMLとして表示する関数"
    (with-current-buffer buf
      (funcall mew-summary-html-render-func
               (point-min) (point-max))
      (goto-char (point-min))
      (insert "\n")))

(provide 'convertdoc)

