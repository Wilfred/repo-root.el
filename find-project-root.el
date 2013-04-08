;;; find-project-root.el -- find the root directory of a VCS project

;;; Commentary

;; Finds the root of the project path for Git and Subversion
;; projects. More VCS systems coming.

;;; License:

;; This file is not part of GNU Emacs.
;; However, it is distributed under the same license.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code

(autoload 'vc-git-root "vc-git")
(autoload 'vc-svn-root "vc-svn")
(require 'vc-svn) ;; fixme: vc-svn-root requires vc-svn-admin-directory loaded

(defun find-project-root (&optional path)
  "Find the absolute path to the root of the project that contains PATH.
Usually, this is the root of VCS project (git, svn, etc). Returns
nil when no project root is found. Results have the form
\"/tmp/foo\", never with a trailing slash. Results are always
absolute paths.

If PATH isn't specified, defaults to `default-directory'.
This is usually what you want."
  (let* ((file-path (or path default-directory))
         (root-path (or (vc-git-root file-path)
                        (vc-svn-root file-path))))
    (if root-path
        (directory-file-name
         (expand-file-name root-path)))))

(defalias 'fpr--git-root 'vc-git-root
  "Find the root path of the git repository that contains FILE.")

(defalias 'fpr--svn-root 'vc-svn-root
  "Find the root path of the git repository that contains FILE.")

;; todo: send a patch for Emacs upstream to implement vc-cvs-root
(defun fpr--cvs-root (file)
  "Find the root path of the CVS repository that contains FILE."
  (let* ((absolute-path (expand-file-name file))
         (directory-path (file-name-directory absolute-path)))
    (locate-dominating-file
     directory-path
     (lambda (dir)
       (not 
        (member "CVS" (directory-files dir)))))))

(provide 'find-project-root)
;;; find-project-root.el ends here
