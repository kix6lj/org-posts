((nil
  . (;; (eval . (progn
     ;;           ((setq-local org-jekyll-post-link-follow
     ;;                        (lambda (path)
     ;;                          (org-open-file-with-emacs path)))

     ;;            (setq-local org-jekyll-post-link-export
     ;;                        (lambda (path desc format)
     ;;                          (cond
     ;;                           ((eq format 'html)
     ;;                            (format "<a href=\"{%% post_url %s %%}\">%s</a>" path desc)))))

     ;;            (org-add-link-type "jekyll-post" 'org-jekyll-post-link-follow 'org-jekyll-post-link))))
     (eval . (setq-local my-project-path
                         (file-name-directory
                          (let ((d (dir-locals-find-file "./")))
                            (if (stringp d) d (car d))))))
     (eval . (progn
               (defun org-jekyll-link-follow (path)
                 (org-open-file-with-emacs path))
               
               (defun org-jekyll-link-path (path channel)
                 (let* ((input-file-path (plist-get channel :input-file))
                        (abs-path (if (file-name-absolute-p path)
                                      path
                                    (file-name-concat (file-name-directory
                                                       input-file-path)
                                                      path)))
                        (path-relative-to-root (file-relative-name abs-path my-project-path)))
                   (file-name-with-extension
                    (file-name-sans-extension path-relative-to-root)
                    ".html")))
               
               (defun org-jekyll-link-export (link desc format channel)
                 (progn
                   (pcase format
                     (`html (format "<a href=\"{%% link %s %%}\">%s</a>"
                                    (org-jekyll-link-path link channel)
                                    desc))
                     (t path))))
               
               (org-link-set-parameters "jekyll-link" :follow #'org-jekyll-link-follow :export #'org-jekyll-link-export)))
     
     (eval . (setq org-publish-project-alist
                   `(("blog-posts"
                      :base-directory ,my-project-path
                      :base-extension "org"

                      :publishing-directory "~/blog/"
                      :recursive t
                      :publishing-function org-html-publish-to-html
                      :headline-levels 4
                      :html-extension "html"
                      :body-only t)
                     
                     ("blog-assets"
                      :base-directory ,my-project-path
                      :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php"
                      :exclude ".*/ltximg/.*"
                      :publishing-directory "~/blog/"
                      :recursive t
                      :publishing-function org-publish-attachment)
                     
                     ("blog" :components ("blog-posts" "blog-assets"))))))))
