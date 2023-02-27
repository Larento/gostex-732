# LaTeX GOST7-32 Document Class

# NOTE: This project has been abandonded and what is written below will never be realized.

## What is this?
This package is a LaTeX document class for writing papers under the GOST7-32 Russian Standard. It includes full support for:
* correct document formatting;
* title pages with custom text fields;
* references management;
* image, table and formula management with appendix support;
* completely new Python-based LaTeX wrapper for SymPy for easy formulas printing according to the GOST standard;
* customizable settings in a JSON format that support storing custom variables.

In other words - this package is a dream of mine come true.

## How to use
To begin you need to create a file `settings.json` (or copy `settings.json.example` and rename it). The field named `path` contains all the necessary info about the main LaTeX job name (the main file should be named `<mainFileName>.tex`).

After you setup your settings, you can create your `<mainFileName>.tex` file and compile it like regular LaTeX. 

## File Structure
### `settings.json`
A configuration file, containing all the main settings such as:
* folder and file paths for references and images;
* options for the final release script;
* text used for custom text fields such as the authors name.

### `settings.json.example`
A configuration example file, containing all the necessary configuration file structure for this package to work.

### `.latexmkrc`
A configuration file for latexmk program. The auxillary folder is setup by default to be `.aux` and it is recommended to not change it (but who am I to tell you what to do).

### `images`
A directory to contain your images. Remember to name your images conveniently, so that it's easy to write their name in LaTeX code.

### `gostdoc`
A directory containing all main package files. This folder isn't meant to be renamed or moved (obviously).

### `gostdoc/gostdoc.cls`
A LaTeX document class file, containing all the rules. Don't change it.

### `gostdoc/json.lua`
A simple JSON parser written in one Lua script. Rather convenient, because LuaLaTeX's interpreter doesn't like dealing with external libraries, especially ones installed with LuaRocks.

### `gostdoc/release.lua`
A script for automatic renaming and copying a PDF file for lazy people. It uses variables from `textFields` field in `settings.json`

### `gostdoc/scripts.lua`
An assortment of useful scripts for internal purposes.

### `gostdoc/siunitx.tex`
A `siunitx` package configuration file, containing definitions for SI Units in Cyryllic.
