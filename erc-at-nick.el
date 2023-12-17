;;; erc-at-nick.el ---  -*- lexical-binding: t; -*-

;; Package-Requires: ((emacs "29.1") (erc))
;; Version: 0.0.1
;; Author: Ben Whitley
;; Homepage: https://github.com/purplg/erc-at-nick
;; SPDX-License-Identifier: MIT

;;; Code:
(require 'erc-pcomplete)

(defcustom erc-at-nick-prefix "@"
  "String prefix before all nicks.
This string is prefixed before all nicks to assist with completion
initiating with this character is inserted into the buffer.

Additionally, the prefix is removed when completion is expanded."
  :type 'string)

(defun erc-at-nick-pcomplete (nicks)
  "Replace completion nicks with prefixed versions"
  (mapcar
   (lambda (value) (concat erc-at-nick-prefix value))
   nicks))

(defun erc-at-nick-replace (args)
  (pcase-let ((`(,beg ,end ,newtext) args))
    `(,beg ,end ,(if (derived-mode-p 'erc-mode)
                     (replace-regexp-in-string (concat "^\\(" erc-at-nick-prefix "\\)") "" newtext)
                   newtext))))

(define-erc-module at-nick nil
  "Prefix nicks with an @."
  ((advice-add 'pcomplete-erc-nicks :filter-return 'erc-at-nick-pcomplete)
   (advice-add 'completion--replace :filter-args 'erc-at-nick-replace))
  ((advice-remove 'pcomplete-erc-nicks 'erc-at-nick-pcomplete)
   (advice-remove 'completion--replace 'erc-at-nick-replace)))

(provide 'erc-at-nick)
;;; erc-at-nick.el ends here
