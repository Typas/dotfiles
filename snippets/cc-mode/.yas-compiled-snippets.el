;;; Compiled snippets and support files for `cc-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'cc-mode
                     '(("?" "" "ternary" nil nil nil "/home/typas/.doom.d/snippets/cc-mode/ternary.yas" nil "?")
                       ("switch" "switch (${1:variable}) {\n    case ${2:value}: $0\n        break;\n    default:\n        break;\n}\n" "switch" nil nil nil "/home/typas/.doom.d/snippets/cc-mode/switch.yas" nil nil)
                       ("struct" "typedef struct ${1:name} {\n    $0\n} $1;\n" "struct ... { ... }" nil nil nil "/home/typas/.doom.d/snippets/cc-mode/struct.yas" nil "struct")
                       ("math.yas" "" "math" nil nil nil "/home/typas/.doom.d/snippets/cc-mode/math.yas" nil nil)
                       ("incl" "#include \"${1:local header}\"\n$0\n" "#include \"...\""
                        (doom-snippets-bolp)
                        nil nil "/home/typas/.doom.d/snippets/cc-mode/includelocal.yas" nil nil)
                       ("incs" "#include <${1:header}>\n$0\n" "#include <...>"
                        (doom-snippets-bolp)
                        nil nil "/home/typas/.doom.d/snippets/cc-mode/include.yas" nil nil)
                       ("ifndef" "#ifndef ${1:MACRO}\n\n$0\n\n#endif // $1" "ifndef" nil nil nil "/home/typas/.doom.d/snippets/cc-mode/ifndef.yas" nil nil)
                       ("fndoc" "/**\n * @brief      ${1:function description}\n *\n * @details    ${2:detailed description}\n *\n * @param      ${3:parameters description}\n *\n * @return     ${4:return type}\n */\n$0\n" "function documentation" nil nil nil "/home/typas/.doom.d/snippets/cc-mode/funcdoc.yas" nil nil)
                       ("enum" "enum ${1:name} {\n    $0\n};" "enum" nil nil nil "/home/typas/.doom.d/snippets/cc-mode/enum.yas" nil nil)
                       ("def" "#define $0" "define" nil nil nil "/home/typas/.doom.d/snippets/cc-mode/define.yas" nil nil)))


;;; Do not edit! File generated at Sun Mar 27 07:58:53 2022
