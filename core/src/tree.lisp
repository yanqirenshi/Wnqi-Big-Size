(in-package :wnqi-big-size)

(defun term2plist (term)
  (if (not term)
      (list :|start| :null :|end| :null)
      (list :|start| (if (start term)
                         (local-time:format-timestring nil (start term))
                         :null)
            :|end|   (if (end term)
                         (local-time:format-timestring nil (end term))
                         :null))))

(defun find-tree-node-term (graph child type)
  (let ((class (class-name (class-of child))))
    (if (not (eq 'workpackage class))
        (term2plist nil)
        (cond ((eq :schedule type)
               (term2plist (get-schedule graph child)))
              ((eq :result type)
               (term2plist (get-result graph child)))))))

(defun %find-tree-result (graph child)
  (let ((class (class-name (class-of child))))
    (if (not (eq 'workpackage class))
        (%find-tree-result2plist nil)
        (%find-tree-result2plist (get-result graph child)))))

(defun %find-tree (graph children)
  (when-let ((child (car children)))
    (cons (list :|_id|         (up:%id child)
                :|code|        (up:%id child)
                :|name|        (name child)
                :|description| (or (description child) :null)
                :|schedule|    (find-tree-node-term graph child :schedule)
                :|result|      (find-tree-node-term graph child :result)
                :|children|    (%find-tree graph (find-children graph child))
                :|_class|      (class-name (class-of child)))
          (%find-tree graph (cdr children)))))

(defgeneric find-tree (graph project)
  (:method (graph (source project))
    (list :|_id|         (up:%id source)
          :|code|        (code source)
          :|name|        (name source)
          :|description| (or (description source) :null)
          :|schedule|    (list :|start| :null :|end| :null)
          :|result|      (list :|start| :null :|end| :null)
          :|children|    (%find-tree graph (find-children graph source))
          :|_class|      (class-name (class-of source))))
  (:method (graph (source wbs))
    (list :|_id|         (up:%id source)
          :|code|        (up:%id source)
          :|name|        (name source)
          :|description| (or (description source) :null)
          :|schedule|    (list :|start| :null :|end| :null)
          :|result|      (list :|start| :null :|end| :null)
          :|children|    (%find-tree graph (find-children graph source))
          :|_class|      (class-name (class-of source)))))
