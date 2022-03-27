;;; Compiled snippets and support files for `latex-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'latex-mode
                     '(("tb" "\\textbf{$1}" "textbf" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/textbf.yas" nil nil)
                       ("sum" "\\sum_{$1}^{$2}" "summation" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/sum.yas" nil nil)
                       ("subsec" "\\subsection{$1}\n\n$0" "subsection" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/subsection.yas" nil nil)
                       ("sec" "\\section{$1}\n\n$0" "section" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/section.yas" nil nil)
                       ("prod" "\\prod_{$1}^{$2}\n" "product" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/product.yas" nil nil)
                       ("note" "\\note{$1} $0\n" "note" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/note.yas" nil nil)
                       ("cmd" "\\newcommand{\\\\${1:cmd_name}}${2:[${3:0}]}{$0}\n" "new command" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/newcommand.yas" nil nil)
                       ("codef" "\\inputminted{${1:lang}}{${2:filename}}\n$0\n" "listing code file" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/listfile.yas" nil nil)
                       ("lr" "\\left( $0 \\right)" "left-right" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/leftright.yas" nil nil)
                       ("lab" "\\label{$1}" "label" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/label.yas" nil nil)
                       ("it" "\\begin{itemize}\n  \\item $0\n\\end{itemize}\n" "itemize" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/itemize.yas" nil nil)
                       ("int" "\\int_{$1}^{$2} {$0}\n" "integral" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/integral.yas" nil nil)
                       ("if" "\\IF {$${1:condition}$}\n  $0\n\\ELSE\n\\ENDIF" "if" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/if.yas" nil nil)
                       ("frac" "\\frac{${1:numerator}}{${2:denominator}} $0" "fraction" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/fraction.yas" nil nil)
                       ("fig" "\\begin{figure}[ht]\n  \\centering\n  \\includegraphics[${1:options}]{figures/${2:path.pdf}}\n  \\caption{${3:\\label{fig:${4:label}}} $0}\n\\end{figure}\n" "figure" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/figure.yas" nil nil)
                       ("eq" "\\begin{equation}\n${1:\\label{eqn:$2}}\n  $0\n\\end{equation}\n" "equation" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/equation.yas" nil nil)
                       ("enum" "\\begin{enumerate}\n  \\item $0\n\\end{enumerate}\n" "enumerate" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/enumerate.yas" nil nil)
                       ("emph" "\\emph{$1} $0\n" "emphasis" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/emphasis.yas" nil nil)
                       ("desc" "\\begin{description}\n  \\item[$1] $0\n\\end{description}\n" "description" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/description.yas" nil nil)
                       ("code" "\\begin{minted}{${1:lang}}\n  $0\n\\end{minted}\n" "code" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/code.yas" nil nil)
                       ("cite" "\\cite{$1} $0\n" "cite" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/cite.yas" nil nil)
                       ("cap" "\\caption{$1} $0" "caption" nil nil nil "/home/typas/.doom.d/snippets/latex-mode/caption.yas" nil nil)
                       ("__tex" "\\documentclass[12pt,a4paper,xetex]{article}\n\\usepackage{amsmath}\n\\usepackage{unicode-math}\n\\usepackage{xeCJK}\n\\usepackage{mathtools}\n\\usepackage{parskip}\n\\usepackage{xcolor}\n\\usepackage{graphicx} % includegraphics\n\\usepackage{caption} % includegraphics\n\\usepackage{fontspec} % font styles\n\\usepackage{diffcoeff} % differential equation\n\\usepackage{minted} % code listing\n\\usepackage[vlined]{algorithm2e} % pseudo codes\n${1:\\usepackage\\{tabularray\\} % table for LaTeX3}\n${2:\\usepackage\\{booktabs\\} % table}\n${3:\\usepackage\\{titlesec\\} % change section style\n\\setcounter\\{secnumdepth\\}\\{$4\\} % titlesec\n\\titleformat\\{\\section\\}\\{\\Large\\bfseries\\}\\{\\thesection.\\,\\}\\{1em\\}\\{\\} % titlesec\n\\titleformat\\{\\subsection\\}\\{\\large\\bfseries\\}\\{\\thesubsection\\,\\}\\{1em\\}\\{\\} % titlesec}\n\\setmainfont{XITS}\n\\setmathfont{XITS Math}\n\\setmonofont[\nItalicFont={JuliaMono RegularItalic},\nBoldItalicFont={JuliaMono SemiBoldItalic},\nBoldFont={Fira Code SemiBold},\nStylisticSet={3,8}\n]{Fira Code}\n\\setCJKmainfont{Noto Serif CJK TC} % xeCJK\n\\setCJKsansfont{Noto Sans CJK TC} % xeCJK\n\\setCJKmonofont[\nBoldFont={Noto Sans CJK TC Bold},\nBoldItalicFont={Noto Sans CJK TC Medium},\nItalicFont={Noto Sans CJK TC Light}\n]{Noto Sans CJK TC Regular} % xeCJK\n\\setlength{\\parskip}{.5em} % parskip\n\\setlength{\\parindent}{2em} % parskip\n\\XeTeXlinebreaklocale \"zh\"\n\\XeTeXlinebreakskip = 0pt plus 1pt\n\\linespread{1.36}\n\n\\title{$5}\n\\date{\\today}\n\\author{$6}\n\n\\begin{document}\n\\maketitle\n\n$0\n\n\\end{document}\n\n% Local Variables:\n% TeX-command-extra-options: \"-shell-escape\"\n% End:\n" "Latex header" nil
                        ("file templates")
                        nil "/home/typas/.doom.d/snippets/latex-mode/__tex" nil nil)))


;;; Do not edit! File generated at Sun Mar 27 07:58:53 2022
