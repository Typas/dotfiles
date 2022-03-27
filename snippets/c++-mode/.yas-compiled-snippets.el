;;; Compiled snippets and support files for `c++-mode'
;;; contents of the .yas-setup.el support file:
;;;
(defun yas-c++-class-name (str)
  "Search for a class name like `DerivedClass' in STR
(which may look like `DerivedClass : ParentClass1, ParentClass2, ...')
If found, the class name is returned, otherwise STR is returned"
  (yas-substr str "[^: ]*"))

(defun yas-c++-class-method-declare-choice ()
  "Choose and return the end of a C++11 class method declaration"
  (yas-choose-value '(";" " = default;" " = delete;")))

;; (defun yas-c++-using-std-p ()
;;   "Return non-nil if 'using namespace std' is found at the top of this file."
;;   (save-excursion
;;     (goto-char (point-max))
;;     (or (search-forward "using namespace std;" 512 t)
;;         (search-forward "std::" 1024 t))))
;;; Snippet definitions:
;;;
(yas-define-snippets 'c++-mode
                     '(("vec" "std::vector<${1:Class}> ${2:var}${3:($4)};" "vector" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/vector.yas" nil nil)
                       ("try" "try {\n    $0\n} catch (${1:type}) {\n}" "try" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/try.yas" nil nil)
                       ("temp" "template<${1:$$(yas/choose-value '(\"typename\" \"class\"))} ${2:T}>" "template" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/template.yas" nil nil)
                       ("sclass" "class ${1:Name} {\npublic:\n    ${1:$(yas-c++-class-name yas-text)}(); // constructor\n    ${2:virtual ~${1:$(yas-c++-class-name yas-text)}();} // destructor\n    $0\nprivate:\n};\n" "simple class" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/sclass.yas" nil nil)
                       ("opne" "bool ${1:MyClass}::operator!=(const $1 &other) const {\n     return !(*this == other);\n}\n" "operator!=" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/operator_notequal.yas" nil nil)
                       ("ns" "namespace ${1:name}" "namespace" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/namespace.yas" nil nil)
                       ("merge" "std::merge(std::begin(${1:container}), std::end($1),\nstd::begin(${2:another}), std::end($2), std::begin(${3:destination}));" "merge" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/merge.yas" nil nil)
                       ("map" "std::map<${1:type1}$0> ${2:var};" "map" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/map.yas" nil nil)
                       ("lam" "[$1] ($2) { $0 }" "lambda" nil
                        ("c++11")
                        nil "/home/typas/.doom.d/snippets/c++-mode/lambda.yas" nil nil)
                       ("forit" "for (auto ${1:iter}=${2:var}.begin(); $1!=$2.end(); ++$1) {\n    $0\n}" "for iteration" nil
                        ("c++11")
                        nil "/home/typas/.doom.d/snippets/c++-mode/for_iteration.yas" nil nil)
                       ("foreach" "std::for_each(std::begin(${1:container}), std::end($1), []($2)) {\n    $0\n}\n" "for_each" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/for_each.yas" nil nil)
                       ("find" "auto snip_pos = std::find(std::begin(${1:container}), std::end($1), ${2:value});\nif (pos != std::($1)) {\n    $0\n}" "find" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/find.yas" nil nil)
                       ("eq" "if (std::equal(std::begin(${1:container}), std::end($1), std::begin($2))) {\n    $0\n}\n" "equal" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/equal.yas" nil nil)
                       ("endl" "std::endl\n" "endl" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/endl.yas" nil nil)
                       ("cout" "std::cout << $0;" "cout" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/cout.yas" nil nil)
                       ("countif" "auto n = std::count_if(std::begin(${1:container}), std::end($1), []($2) {\n    $0\n});" "countif" nil
                        ("c++11")
                        nil "/home/typas/.doom.d/snippets/c++-mode/countif.yas" nil nil)
                       ("count" "auto n = std::count(std::begin(${1:container}), std::end($1), $2);$0" "count" nil
                        ("c++11")
                        nil "/home/typas/.doom.d/snippets/c++-mode/count.yas" nil nil)
                       ("cp" "std::copy(std::begin(${1:container}), std::end($1), std::begin($2));$0" "copy" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/copy.yas" nil nil)
                       ("cls" "class ${1:Name} {\npublic:\n${2:  ${3://! Default constructor\n  }${1:$(yas-c++-class-name yas-text)}()${4:;$(yas-c++-class-method-declare-choice)}\n}${5:  ${6://! Copy constructor\n  }${1:$(yas-c++-class-name yas-text)}(const ${1:$(yas-c++-class-name yas-text)} &other)${7:;$(yas-c++-class-method-declare-choice)}\n}${8:  ${9://! Move constructor\n  }${1:$(yas-c++-class-name yas-text)}(${1:$(yas-c++-class-name yas-text)} &&other)${10: noexcept}${11:;$(yas-c++-class-method-declare-choice)}\n}${12:  ${13://! Destructor\n  }${14:virtual }~${1:$(yas-c++-class-name yas-text)}()${15: noexcept}${16:;$(yas-c++-class-method-declare-choice)}\n}${17:  ${18://! Copy assignment operator\n  }${1:$(yas-c++-class-name yas-text)}& operator=(const ${1:$(yas-c++-class-name yas-text)} &other)${19:;$(yas-c++-class-method-declare-choice)}\n}${20:  ${21://! Move assignment operator\n  }${1:$(yas-c++-class-name yas-text)}& operator=(${1:$(yas-c++-class-name yas-text)} &&other)${22: noexcept}${23:;$(yas-c++-class-method-declare-choice)}\n}\n$0\nprotected:\nprivate:\n};\n" "class11" nil
                        ("c++11")
                        nil "/home/typas/.doom.d/snippets/c++-mode/class11.yas" nil nil)
                       ("cin" "std::cin >> $0;" "cin" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/cin.yas" nil nil)
                       ("cerr" "std::cerr << $0;" "cerr" nil nil nil "/home/typas/.doom.d/snippets/c++-mode/cerr.yas" nil nil)))


;;; Do not edit! File generated at Sun Mar 27 07:58:53 2022
