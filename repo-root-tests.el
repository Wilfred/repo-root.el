(require 'ert)
(require 'repo-root)

(ert-deftest repo-root-test-git ()
    (let* ((git-repo-root "/home/wilfred/personal/find-project-root.el/test_repos/git")
           (git-file-path (concat (file-name-as-directory git-repo-root) "features/initialization.feature")))
      (should
       (equal
        git-repo-root
        (repo-root git-file-path)))))

(defun run-repo-root-tests ()
  (interactive)
  (ert-run-tests-interactively "repo-root-test-"))

(repo-root-svn-root "/home/wilfred/personal/find-project-root.el/test_repos/svn/Makefile")

(repo-root-cvs-root "/home/wilfred/personal/find-project-root.el/test_repos/cvs/emacs/tour/emacs.css")
