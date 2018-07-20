(in-package :cl-user)
(defpackage wnqi-big-size-api.config
  (:use :cl)
  (:import-from #:sephirothic
                #:make-tree
                #:fruit*
                #:code)
  (:export #:config
           #:print-config
           #:*application-root*))
(in-package :wnqi-big-size-api.config)

(defparameter *application-root* (asdf:system-source-directory :wnqi-big-size-api))

(defvar *tree-stor* (merge-pathnames #P"src/data/" *application-root*))
(defvar *tree* (make-tree (ensure-directories-exist *tree-stor*)))

(defvar *application-code* :wnqi-big-size-api)

(defun get-environments-code (&key (name (uiop:getenv "APP_ENV")))
  (cond ((string= name "development")     :development)
        ((string= name "dev-glpgs-mbpro") :dev-glpgs-mbpro)
        ((string= name "production")      :production)
        (t :unknown)))

(defun get-sephirothic-context ()
  (sephirothic:get-sephirothic-context :tree *tree*
                                       :application-code *application-code*
                                       :environment-code (get-environments-code)))

(defun config (&rest query)
  (multiple-value-bind (tree appl env)
      (get-sephirothic-context)
    (fruit* tree (code appl) (code env) query)))

(defun print-config ()
  (multiple-value-bind (graph appl env appl-code env-code)
      (get-sephirothic-context)
    (format t "Graph: ~a~%" graph)
    (format t " Appl: ~a => ~a~%" appl appl-code)
    (format t "  Env: ~a => ~a~%" env env-code)))

(defun (setf config) (value &rest query)
  (multiple-value-bind (tree appl env)
      (get-sephirothic-context)
    (setf (fruit* tree (code appl) (code env) query)
          value)))

(defun init-config ()
  (setf (config :http :server :port) 55555)
  (setf (config :http :server :type) :woo)
  (setf (config :api  :path :prefix) "/wbs")
  (setf (config :log :error :directory) nil)
  (setf (config :database :data :stor) nil)
  (setf (config :http :response :header :access-control-allow-origin) "http://localhost:8080"))

(init-config)
