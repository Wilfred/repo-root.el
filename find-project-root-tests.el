(require 'ert)

(ert-deftest fpr-test-git ()
    (let* ((git-repo-root "/home/wilfred/personal/find-project-root.el/test_repos/git")
           (git-file-path (concat (file-name-as-directory git-repo-root) "features/initialization.feature")))
      (should
       (equal
        git-repo-root
        (find-project-root git-file-path)))))

(defun run-fpr-tests ()
  (interactive)
  (ert-run-tests-interactively "fpr-test-"))

(fpr--svn-root "/home/wilfred/personal/find-project-root.el/test_repos/svn/Makefile")

(fpr--cvs-root "/home/wilfred/personal/find-project-root.el/test_repos/cvs/emacs/tour/emacs.css")
