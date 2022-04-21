;;; cli.el -*- lexical-binding: t; -*-

;; disalbe ahead-of-time native compilation
(advice-add #'native-compile-async :override #'ignore)
