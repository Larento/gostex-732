# This shows how to use lualatex (http://en.wikipedia.org/wiki/LuaTeX)
# with latexmk.  
#
#   WARNING: The method shown here is suitable only for ver. 4.51 and
#            later of latexmk, not for earlier versions.
#

$pdf_mode = 4;
$postscript_mode = $dvi_mode = 0;
$out_dir = "./.aux";
ensure_path( 'TEXINPUTS', './node_modules/gostex-732//' );