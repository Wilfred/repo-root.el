;;; repo-root.el -- find the root directory of a VCS project

;;; Commentary

;; Finds the root of the project path for Git, SVN and Darcs
;; repositories.

;; This is intended for modules that want to discover the currently
;; edited project with zero configuration required by the user.

;;; Target Features

;; Detection from version control:
;; * RCS
;; * CVS
;; * Darcs (implemented, needs unit tests)
;; * Bazaar
;; * Mercurial
;; * MKS

;; Detection from build tools:
;; * lein
;; * sbt
;; * maven
;; * rebar
;; * bundler

;; Detection from editors
;; * Eclipse (.project)
;; * PyDev (.pydevproject)
;; * Emacs Projectile (.projectile)

;;; Similar projects:

;; * https://github.com/jrockway/eproject has a concept of a generic
;;   project
;; * https://github.com/bbatsov/projectile supports project detection,
;;   or an explicit .projectile file.
;; * http://code.google.com/p/emacs-project-mode/ requires the user to
;;   interactively state their project paths, and saves
;;   ~/.emacs.d/PROJECT-NAME.proj
;;
;; Several others are documented at http://www.emacswiki.org/emacs/CategoryProject

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

(require 'f)

(autoload 'vc-git-root "vc-git")
(autoload 'vc-svn-root "vc-svn")

(defun repo-root (&optional path)
  "Find the absolute path to the root of the project that contains PATH.
Usually, this is the root of VCS project (git, svn, etc). Returns
nil when no project root is found. Results have the form
\"/tmp/foo\", never with a trailing slash. Results are always
absolute paths.

If PATH isn't specified, defaults to `default-directory'.
This is usually what you want."
  (let* ((file-path (or path default-directory))
         (root-path (or (repo-root-git-root file-path)
                        (repo-root-svn-root file-path)
                        (repo-root-cvs-root file-path)
                        (repo-root-darcs-root file-path))))
    (if root-path
        (directory-file-name
         (expand-file-name root-path)))))

(defalias 'repo-root-git-root 'vc-git-root
  "Find the root path of the git repository that contains FILE.")

(defun repo-root--locate-dominating-file-top (file name)
  "Look up the directory hierarchy from FILE for a directory containing NAME.
If multiple directories are found, return the parentmost (i.e. closest to /).

Note unlike `locate-dominating-file', NAME may be a file or directory."
  (let* ((absolute-path (f-expand file))
         (directory-path (f-dirname absolute-path))
         (current-dir-matches (f-exists? (f-join directory-path name))))
    (if (f-root? directory-path)
        (if current-dir-matches
            ;; / contains NAME, so return this directory.
            directory-path
          ;; / does not contain NAME, we're done.
          nil)
      (or
       ;; If there's an ancestor directory that contains this NAME, return it.
       (repo-root--locate-dominating-file-top
        (f-parent file) name)
       ;; Otherwise, return this directory if it contains NAME.
       (if current-dir-matches directory-path)))))

;; Note vc-svn-root doesn't exist on Emacs 23.4. In Subversion v1.7
;; only the root has a .svn directory, whereas previously every
;; directory has a .svn directory. We support both.
(defun repo-root-svn-root (file)
  "Find the root path of the Subversion repository that contains FILE."
  (repo-root--locate-dominating-file-top file ".svn"))

;; todo: send a patch for Emacs upstream to implement vc-cvs-root
(defun repo-root-cvs-root (file)
  "Find the root path of the CVS repository that contains FILE."
  (let* ((absolute-path (expand-file-name file))
         (directory-path (file-name-directory absolute-path)))
    (locate-dominating-file
     directory-path
     (lambda (dir)
       (not 
        (member "CVS" (directory-files dir)))))))

;; this is based on vc-darcs-find-root from vc-darcs, but we don't
;; want to pull in a whole package for one small function
(defun repo-root-darcs-root (file)
    "Find the root path of the darcs repository that contains FILE."
  (let* ((absolute-path (expand-file-name file))
         (directory-path (file-name-directory absolute-path)))
    (locate-dominating-file
     directory-path
     "_darcs")))

(provide 'repo-root)
;;; find-project-root.el ends here
