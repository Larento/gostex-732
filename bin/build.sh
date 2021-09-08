#!/usr/bin/env bash
latexmk -r './node_modules/gostex-732/.latexmkrc' main.tex
lua './node_modules/gostex-732/scripts/release.lua'