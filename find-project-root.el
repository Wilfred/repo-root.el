;;; find-project-root.el -- find the root directory of a VCS project

;;; Commentary

;; Finds the root of the project path for Git and Subversion
;; projects. More VCS systems coming.

;;; Code

(autoload 'vc-git-root "vc-git")
(autoload 'vc-svn-root "vc-svn")
(require 'vc-svn) ;; fixme: vc-svn-root requires vc-svn-admin-directory loaded

;; fixme: returns the enclosing git directory, even if svn is inside
(defun find-project-root (&optional path)
  "Find the absolute path to the root of the project that contains PATH.
Usually, this is the root of VCS project (git, svn, etc). Returns
nil when no project root is found.

If PATH isn't specified, defaults to `default-directory'.
This is usually what you want."
  (let* ((file-path (or path default-directory))
         (root-path (or (vc-git-root file-path)
                        (vc-svn-root file-path))))
    (if root-path
        (expand-file-name root-path))))

(provide 'find-project-root)
;;; find-project-root.el ends here
