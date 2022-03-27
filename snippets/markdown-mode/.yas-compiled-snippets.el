;;; Compiled snippets and support files for `markdown-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'markdown-mode
                     '(("table" "| ${1:header} | ${2:header} |\n| --- | --- |\n| $0 |  |" "Table" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/table.yas" nil nil)
                       ("ln" "[${1:Link Text}][${2:Ref Label}] $0" "Referenced Link" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/refereced_link.yas" nil nil)
                       ("label" "[${1:Ref label}]: ${2:URL} $3\n$0\n" "Referenced Label" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/refereced_label.yas" nil nil)
                       ("img" "![${1:Alt Text}][${2: Ref Label}] $0\n" "Referenced Image" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/refereced_image.yas" nil nil)
                       ("inln" "[${1:Link Text}](${2:URL} $3) $0" "Inline link" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/inline_link.yas" nil nil)
                       ("inimg" "![$1](${2:URL} $3) $0" "Inline Image Link" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/inline_image.yas" nil nil)
                       ("h6" "###### ${1:Header 6} ######\n\n$0" "Header 6" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/header6.yas" nil nil)
                       ("h5" "##### ${1:Header 5} #####\n\n$0" "Header 5" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/header5.yas" nil nil)
                       ("h4" "#### ${1:Header 4} ####\n\n$0" "Header 4" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/header4.yas" nil nil)
                       ("h3" "### ${1:Header 3} ###\n\n$0" "Header 3" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/header3.yas" nil nil)
                       ("h2" "## ${1:Header 2} ##\n\n$0" "Header 2" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/header2.yas" nil nil)
                       ("h1" "# ${1:Header 1} #\n\n$0" "Header 1" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/header1.yas" nil nil)
                       ("code_block.yas" "\\`\\`\\` ${1:lang}\n$0\n\\`\\`\\`\n" "Code Block" nil nil nil "/home/typas/.doom.d/snippets/markdown-mode/code_block.yas" nil nil)))


;;; Do not edit! File generated at Sun Mar 27 07:58:53 2022
