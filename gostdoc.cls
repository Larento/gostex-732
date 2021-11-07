\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{gostdoc}
%---------------------------------------------------------%
% CLASS OPTIONS
%---------------------------------------------------------%

%---------------------------------------------------------%
% DOCUMENT LAYOUT AND PAGE SETUP
%---------------------------------------------------------%
\LoadClass[a4paper, 14pt]{extarticle}
\RequirePackage[
    left=30mm, right=15mm,%
    top=20mm,bottom=20mm,%
    includefoot,heightrounded%
]{geometry}

\RequirePackage{calc}
\newlength{\spacewidth}
\setlength{\spacewidth}{\widthof{\space}}

% Stretch text to full width with no hyphenation
\tolerance=1
\emergencystretch=\maxdimen
\hyphenpenalty=10000
\hbadness=10000

% Put floats at the top of the page
\makeatletter
\setlength{\@fptop}{0pt}
\makeatother

% Line spacing
\RequirePackage{setspace}
\spacing{1.5}

% Paragraph indentation
\RequirePackage{indentfirst}
\parindent=1.25cm

%---------------------------------------------------------%
% AUTOMATION
%---------------------------------------------------------%
\RequirePackage{lipsum}
% \RequirePackage{lua-visual-debug}

% Lua scripts support from scripts.lua file
\RequirePackage{luacode}
% \RequirePackage{luapackageloader}
\directlua{scripts = dofile("node_modules/gostex-732/scripts/scripts.lua")}
\directlua{settings = scripts.loadJSON("settings.json")}

\RequirePackage{pythontex}
\setpythontexworkingdir{../node_modules/gostex-732/scripts}
\begin{pycode}
from equation import *
P = ParameterCollection()
\end{pycode}

\newcommand{\settings}[1]{
    \directlua{tex.sprint(scripts.getTableFields(settings, "\luaescapestring{\unexpanded{#1}}"))}
}

\RequirePackage{ifthen}
\RequirePackage{atveryend}

% Pages, figures, tables and appendix counters
\newcounter{figures}
\newcounter{tables}
\newcounter{appendix}
\setcounter{figures}{0}
\setcounter{tables}{0}
\setcounter{appendix}{0}

\newcommand{\totalpages}{\pageref*{refpages}}
\newcommand{\totalfigures}{\ref*{reffigures}}
\newcommand{\totaltables}{\ref*{reftables}}
\newcommand{\totalappendices}{\ref*{refappendix}}

\newcommand{\createCounterRef}[1]{
    \addtocounter{#1}{-1}\refstepcounter{#1}\label{ref#1}
}

\newcommand{\setCounterRefs}{
    \label{refpages}
    \createCounterRef{figures}
    \createCounterRef{tables}
    \createCounterRef{appendix}
}

\AfterLastShipout{
    \setCounterRefs{}
}

%---------------------------------------------------------%
% LANGUAGE AND FONT
%---------------------------------------------------------%
\RequirePackage{csquotes}
\RequirePackage[russian]{babel}
\RequirePackage{fontspec}
\setmainfont{Times New Roman}

% Font styles
\newcommand{\tinyfont}{\fontsize{10pt}{12pt}\selectfont}
\newcommand{\smallfont}{\fontsize{12pt}{14.4pt}\selectfont}
\newcommand{\bigfont}{\fontsize{16pt}{19.2pt}\selectfont}
\newcommand{\hugefont}{\fontsize{20pt}{24pt}\selectfont}
\newcommand{\gigafont}{\fontsize{22pt}{26.4pt}\selectfont}
\newcommand{\structuralsectionfont}{\bigfont\bfseries\MakeUppercase}
\newcommand{\regularsectionfont}{\bigfont\bfseries}

% Text underline
\RequirePackage[normalem]{ulem}
\newcommand{\ulinethick}[1]{%
    \renewcommand{\ULthickness}{1.5pt}%
       \uline{#1}%
    \renewcommand{\ULthickness}{.4pt}%
}

%---------------------------------------------------------%
% TITLES
%---------------------------------------------------------%
\RequirePackage{titlesec}
\newcommand{\sectionbreak}{\clearpage}

% Title spacing
\titlespacing*{\section}{\parindent}{1em}{0pt}
\titlespacing*{\subsection}{\parindent}{1em}{0pt}
\titlespacing*{\subsubsection}{\parindent}{1em}{0pt}

% Crazy hacks
\RequirePackage{xparse}
\makeatletter
\def\@hangfrom#1{\setbox\@tempboxa\hbox{{#1}}%
      \hangindent 0pt%\wd\@tempboxa
      \noindent\box\@tempboxa}
\makeatother

\newcommand{\regularsectionformat}{
    \titleformat{\section}[hang]{\regularsectionfont}{\thesection}{0.4em}{\hspace{0pt}}[]
    \titleformat{\subsection}[hang]{\regularsectionfont}{\thesubsection}{0.4em}{\hspace{0pt}}[]
    \titleformat{\subsubsection}[hang]{\regularsectionfont}{\thesubsubsection}{0.4em}{\hspace{0pt}}[]
}
\newcommand{\structuralsectionformat}{
    \titleformat{\section}[hang]{\structuralsectionfont}{}{0pt}{\centering}[]
}
\regularsectionformat

% Ability to add a section without numbering with section*{}
% With correct hyperlikns
\let\oldsection\section
\makeatletter
\newcounter{@secnumdepth}
\RenewDocumentCommand{\section}{s o m}{%
  \IfBooleanTF{#1}
    {\setcounter{@secnumdepth}{\value{secnumdepth}}% Store secnumdepth
     \setcounter{secnumdepth}{0}% Print only up to \chapter numbers
     \oldsection{#3}% \section*
     \setcounter{secnumdepth}{\value{@secnumdepth}}}% Restore secnumdepth
    {\IfValueTF{#2}% \section
       {\oldsection[#2]{#3}}% \section[.]{..}
       {\oldsection{#3}}}% \section{..}
}

\def\@hangfrom#1{\setbox\@tempboxa\hbox{{#1}}%
      \hangindent 0pt%\wd\@tempboxa
      \noindent\box\@tempboxa}
\makeatother

\newcommand{\structuralsection}[1]{
    \structuralsectionformat
    \section*{#1}
    \regularsectionformat
}

\newcommand{\structuralsectionNOTOC}[1]{
    \structuralsectionformat
    \newpage
    \centerline{\structuralsectionfont#1}
    \regularsectionformat
}

\renewcommand{\abstract}{\structuralsectionNOTOC{РЕФЕРАТ}}
\newcommand{\task}{\structuralsectionNOTOC{ИНДИВИДУАЛЬНОЕ ЗАДАНИЕ}}
\newcommand{\introduction}{\structuralsection{ВВЕДЕНИЕ}}
\newcommand{\conclusion}{\structuralsection{ЗАКЛЮЧЕНИЕ}}

\renewcommand{\appendix}{
    \refstepcounter{appendix}
    \structuralsection{ПРИЛОЖЕНИЕ \Asbuk{appendix}}
    \setcounter{figure}{0}
    \setcounter{table}{0}
    \renewcommand{\thefigure}{\Asbuk{appendix}.\arabic{figure}}
    \renewcommand{\thetable}{\Asbuk{appendix}.\arabic{table}}
}

%---------------------------------------------------------%
% LISTS
%---------------------------------------------------------%
\RequirePackage{enumitem}
\AddEnumerateCounter{\Asbuk}{\@Asbuk}{А}
\AddEnumerateCounter{\asbuk}{\@asbuk}{а}
\setlist{nosep, labelsep=\spacewidth, wide}
\directlua{scripts.setListMargins(3)}

% Three types of lists
\newlist{itemlist}{enumerate}{3}
\newlist{letteredlist}{enumerate}{2}
\newlist{numberedlist}{enumerate}{3}

\setlist[itemlist, 1]{label=--, widest=--}
\setlist[itemlist, 2]{label=\asbuk*), widest=_)}
\setlist[itemlist, 3]{label=\arabic*), widest=99)}

\setlist[letteredlist, 1]{label=---, widest=_)}
\setlist[letteredlist, 2]{label=\arabic*), widest=99)}

\setlist[numberedlist, 1]{label=\arabic*., widest=99)}
\setlist[numberedlist, 2]{label=\arabic{numberedlisti}.\arabic*., widest=99.99)}
\setlist[numberedlist, 3]{label=\arabic{numberedlisti}.\arabic{numberedlistii}.\arabic*., widest=99.99.9)}

%---------------------------------------------------------%
% CAPTIONS
%---------------------------------------------------------%
\RequirePackage{caption}
\DeclareCaptionLabelSeparator{emdash}{ --- }
\captionsetup{labelsep=emdash, figurename=Рисунок, tablename=Таблица, tableposition=top, singlelinecheck=false, format=hang, justification=centering, font={singlespacing}}
\captionsetup[table]{justification=raggedright}

%---------------------------------------------------------%
% TABLE OF CONTENTS
%---------------------------------------------------------%
\RequirePackage{tocloft}
% \RequirePackage{cmap}
\RequirePackage[hidelinks]{hyperref}
\addto\captionsrussian{\renewcommand{\contentsname}{Содержание}}

\renewcommand{\cfttoctitlefont}{\hfill\structuralsectionfont}
\renewcommand{\cftaftertoctitle}{\hfill\hfill}
\renewcommand{\cftaftertoctitleskip}{0px}

\renewcommand{\cftsecfont}{\normalfont}
\renewcommand{\cftsubsecfont}{\normalfont}
\renewcommand{\cftsubsubsecfont}{\normalfont}

\renewcommand{\cftsecpagefont}{\normalfont}
\renewcommand{\cftsubsecpagefont}{\normalfont}
\renewcommand{\cftsubsubsecpagefont}{\normalfont}

\cftsetindents{section}{0em}{1.25em}
\cftsetindents{subsection}{1.25em}{2em}
\cftsetindents{subsubsection}{3.25em}{2.75em}

\renewcommand{\cftsecleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftsubsecleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftsubsubsecleader}{\cftdotfill{\cftdotsep}}

\renewcommand{\cftdotsep}{0.25}
\renewcommand{\cftbeforesecskip}{0pt}

\newcommand{\toc}{%
    \newpage
    \begin{spacing}{1.75}%
        \tableofcontents%
    \end{spacing}%
}

%---------------------------------------------------------%
% GRAPHICS
%---------------------------------------------------------%
\RequirePackage{
    graphicx,
    graphbox,
    pdfpages,
    luatex85
}

\newcommand{\imagePath}{\directlua{tex.sprint(settings["path"]["images"])}}

% Regular labeled figure
\newcommand{\insertfigure}[3][\linewidth]{
    \begin{figure}[!ht]%
        \centering%
        \includegraphics[width=#1]{\imagePath/#2}%
        \caption{#3}\label{fig:#2}%
        \refstepcounter{figures}
        \vspace{-10pt}
    \end{figure}%
}

\newcommand{\insertfigurenocap}[2][\linewidth]{
    \begin{figure}[!ht]%
        \centering%
        \includegraphics[width=#1]{\imagePath/#2}%
        \refstepcounter{figures}
    \end{figure}%
}

% Figure with some description above label
\newcommand{\insertfigurewithdesc}[4][\linewidth]{
    \begin{figure}[!ht]
        \centering
        \includegraphics[width=#1]{\imagePath/#2}
        \caption*{#3}
        \vspace{-10pt}
        \caption{#4}\label{fig:#2}
        \refstepcounter{figures}
        \vspace{-10pt}
    \end{figure}
}

\includepdfset{pages={-}}

\newcommand{\insertpdf}[2][]{
    \includepdf[#1]{\imagePath/#2.pdf}
}

%---------------------------------------------------------%
% TABLES
%---------------------------------------------------------%
\RequirePackage{
    array,
    tabularx
}

\renewcommand{\tabularxcolumn}[1]{m{#1}}
\newcolumntype{L}{>{\raggedright\arraybackslash} X}
\newcolumntype{C}{>{\centering\arraybackslash} X}
\newcolumntype{R}{>{\raggedleft\arraybackslash} X}
\newcolumntype{x}[1]{>{\centering\arraybackslash}m{#1}}

\newenvironment{inserttable}[3][1.5]{
    \begin{table}[!ht]%
    \caption{#3}\label{tab:#2}%
        \centering
        \begin{spacing}{#1}
}{
        \end{spacing}
        \refstepcounter{tables}
        \vspace{-10pt}
    \end{table}%
}

%---------------------------------------------------------%
% REFERENCES
%---------------------------------------------------------%
\RequirePackage[
    backend=biber,
    bibstyle=gost-numeric,
    citestyle=numeric-comp,
    language=auto,
    babel=other,
    sorting=ntvy,
    doi=false,
    eprint=false,
    isbn=false,
    dashed=false,
    url=false
]{biblatex}
\bibliography{references}
\nocite{*}

\newcommand{\references}{
    \structuralsection{СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ}
    \printbibliography[heading=none]
}
%---------------------------------------------------------%
% EQUATIONS
%---------------------------------------------------------%
\RequirePackage{
    amsmath,
    amsfonts,
    amssymb,
    siunitx,
    unicode-math
}
\setmathfont{XITS Math}

\input{node_modules/gostex-732/include/siunitx}

\sisetup{
    detect-weight,
    detect-mode,
    range-units = single,
    range-phrase = \text{ -- },
    output-decimal-marker = {,},
    per-mode=fraction,
    inter-unit-product = \ensuremath{{}\times{}}
}

%---------------------------------------------------------%
% FIELDS
%---------------------------------------------------------%
\newcommand{\textfield}[2]{%
    \setlength{\tabcolsep}{0.5em}%
    \noindent%
    \begin{tabularx}{\textwidth}{@{} l R @{}}%
        #1 & \uline{#2 \hfill}
    \end{tabularx}%
}

\newcommand{\textfieldShortLeft}[3][0em]{%
    \setlength{\tabcolsep}{0.5em}%
    \noindent%
    \begin{tabularx}{\textwidth}{@{} l L @{}}%
        #2 & \uline{#3 \hspace{#1}}
    \end{tabularx}%
}

\newcommand{\textfieldShortLeftNoUL}[3][0em]{%
    \setlength{\tabcolsep}{0.2em}%
    \noindent%
    \begin{tabularx}{\textwidth}{@{} l L @{}}%
        #2 & #3 \hspace{#1}
    \end{tabularx}%
}

\newcommand{\textfieldLabel}[3]{%
    \setlength{\tabcolsep}{0.5em}%
    \renewcommand{\arraystretch}{0.45}%
    \noindent%
    \begin{tabularx}{\textwidth}{@{} l C @{}}%
        #1      & \uline{#2 \hfill} \\
        \hfill  & #3
    \end{tabularx}%
}

\newcommand{\textfieldShortRightDoubleLabel}[4]{%
    \setlength{\tabcolsep}{0.5em}%
    \renewcommand{\arraystretch}{0.45}%
    \noindent%
    \begin{tabularx}{\textwidth}{@{} l C x{6em} x{9em} @{}}%
        #1 & \hfill & \uline{\hfill} & \uline{\hfill #2 \hfill} \\
        \hfill & \hfill & #3 & #4
    \end{tabularx}%
}

%---------------------------------------------------------%
% TITLE PAGE MACROS
%---------------------------------------------------------%
\newcommand{\logo}{\includegraphics[height=30mm, align=c]{include/logo}}

\newcommand{\titleheadertext}{
    Министерство науки и высшего образования Российской Федерации Федеральное государственное бюджетное образовательное учреждение высшего образования\newline
    «Московский государственный технический университет имени Н.Э. Баумана (национальный исследовательский университет)» (МГТУ им. Н.Э. Баумана)
}

\newcommand{\titleheader}{
    \begin{spacing}{1}
        \centering
        \begin{tabularx}{\linewidth}{|c|C|}
            \hline
            \logo & \smallfont\textbf\titleheadertext\\
            \hline
        \end{tabularx}
    \end{spacing}
}

\newcommand{\titleform}{
    \begin{spacing}{2.5}
        \textfieldLabel{Студент}{\settings{textFields/fullname}}{\smallfont\textit{фамилия, имя, отчество}}
        \textfield{Группа}{\settings{textFields/group}}
        \textfield{Тип практики}{\settings{textFields/practiceType}}
        \textfield{Название предприятия}{\settings{textFields/factory}}

        \vspace{3em}

        \textfieldShortRightDoubleLabel{Студент}{\textbf{\settings{textFields/student}}}{\textit{подпись, дата}}{\textit{фамилия, и.о.}}
        \textfieldShortRightDoubleLabel{Руководитель практики}{\textbf{\settings{textFields/prof}}}{\smallfont\textit{подпись, дата}}{\smallfont\textit{фамилия, и.о.}}
        \textfieldShortLeft[5em]{Оценка}{}
    \end{spacing}
}

\RequirePackage{fancyhdr}
\fancypagestyle{titlepage}{%
    \fancyhf{}%
    \cfoot{\textit{\the\year г.}}%
    \renewcommand{\headrulewidth}{0mm}%
}

\newcommand{\ifStringsEqual}[3]{%
    \ifthenelse{\equal{#1}{#2}}{#3}{}
}

\newcommand{\addTitlePage}[2]{
    \ifStringsEqual{\directlua{tex.sprint(settings["doctype"])}}{#1}{
        \renewcommand{\titlepage}{#2}
    }
}

%---------------------------------------------------------%
% DEFAULT TITLE PAGE
% "doctype" = "default"
%---------------------------------------------------------%
\addTitlePage{default}{
    \thispagestyle{titlepage}
}

%---------------------------------------------------------%
% PRACTICE REPORT TITLE PAGE
% "doctype" = "practiceReport"
%---------------------------------------------------------%
\addTitlePage{practiceReport}{
    \thispagestyle{titlepage}
    \titleheader

    \noindent\rule[-1em]{\textwidth}{3pt}
    \noindent\rule[0.75em]{\textwidth}{0.5pt}

    \vspace{-1em}

    \begin{spacing}{2}
        \smallfont\textfield{\MakeUppercase{Факультет}}{\settings{textFields/faculty}}

        \smallfont\textfield{\MakeUppercase{Кафедра}}{\settings{textFields/department}}

        \vspace{3em}

        \centering\hugefont\textbf{\ulinethick{\MakeUppercase{\settings{textFields/doctitle}}}}
    \end{spacing}

    \titleform
    \clearpage
}

%---------------------------------------------------------%
% ESSAY TITLE PAGE
% "doctype" = "essay"
%---------------------------------------------------------%
\addTitlePage{essay}{
    \thispagestyle{titlepage}
    \titleheader

    \noindent\rule[-1em]{\textwidth}{3pt}
    \noindent\rule[0.75em]{\textwidth}{0.5pt}

    \vspace{-1em}

    \begin{spacing}{2}
        \smallfont\textfield{\MakeUppercase{Факультет}}{\settings{textFields/faculty}}

        \smallfont\textfield{\MakeUppercase{Кафедра}}{\settings{textFields/department}}

        \vspace{5em}
    \end{spacing}
    
    \begin{spacing}{1.5}
        \centering\hugefont\textbf{{\MakeUppercase{Реферат}}}

        \centering\hugefont{\settings{textFields/doctitle}}

        \vspace{10em}
    \end{spacing}

    \begin{spacing}{1.5}
        \textfieldShortLeftNoUL{Студент:}{\settings{textFields/student}}
        \textfieldShortLeftNoUL{Группа:}{\settings{textFields/group}}
        \textfieldShortLeftNoUL{Вариант}{\settings{textFields/variant}}
        \textfieldShortLeftNoUL{Преподаватель:}{\settings{textFields/prof}}
    \end{spacing}

    \clearpage
}

%---------------------------------------------------------%
% ESSAY TITLE PAGE
% "doctype" = "hometask"
%---------------------------------------------------------%
\addTitlePage{hometask}{
    \thispagestyle{titlepage}
    \titleheader

    \noindent\rule[-1em]{\textwidth}{3pt}
    \noindent\rule[0.75em]{\textwidth}{0.5pt}

    \vspace{-1em}

    \begin{spacing}{2}
        \smallfont\textfield{\MakeUppercase{Факультет}}{\settings{textFields/faculty}}

        \smallfont\textfield{\MakeUppercase{Кафедра}}{\settings{textFields/department}}

        \vspace{5em}
    \end{spacing}
    
    \begin{spacing}{1.5}
        \centering\hugefont\textbf{{\MakeUppercase{Домашнее задание}}}

        \centering\bigfont{по дисциплине: "\settings{textFields/course}"}

        \vspace{10em}
    \end{spacing}

    \begin{spacing}{1.5}
        \textfieldShortLeftNoUL{Студент:}{\settings{textFields/student}}
        \textfieldShortLeftNoUL{Группа:}{\settings{textFields/group}}
        \textfieldShortLeftNoUL{Вариант}{\settings{textFields/variant}}
        \textfieldShortLeftNoUL{Преподаватель:}{\settings{textFields/prof}}
    \end{spacing}

    \clearpage
}

%---------------------------------------------------------%
% TERM PAPER TITLE PAGE
% "doctype" = "termPaper"
%---------------------------------------------------------%
\RequirePackage{environ}

\makeatletter
\NewEnviron{parlines}[1]{%
  \par
  \if@nobreak\def\kept@nobreak{\@nobreaktrue}\else\def\kept@nobreak{}\fi
  \edef\kept@everypar{\the\everypar}%
  \setbox0=\vbox{\BODY\@@par\xdef\parlinesprevgraf{\the\prevgraf}}%
  \kept@nobreak
  \everypar=\expandafter{\kept@everypar}%
  \ifnum\parlinesprevgraf>#1\relax
    ERROR, too long,\par\vspace{#1\baselineskip}%
  \else
    \BODY\par
    \vspace{\numexpr#1-\parlinesprevgraf\relax\baselineskip}%
  \fi
}
\makeatother

\addTitlePage{termPaper}{
    \thispagestyle{titlepage}
    \titleheader

    \noindent\rule[-1em]{\textwidth}{3pt}
    \noindent\rule[0.75em]{\textwidth}{0.5pt}

    \vspace{-1em}

    \begin{spacing}{2}
    \smallfont\textfield{\MakeUppercase{Факультет}}{\settings{textFields/faculty}}

    \smallfont\textfield{\MakeUppercase{Кафедра}}{\settings{textFields/department}}
    \end{spacing}

    \vspace{5em}

    \begin{spacing}{1.5}
        \gigafont\centering\textbf{\MakeUppercase{
            Расчетно-поснительная записка\\
            \hugefont\textit{
                к курсовому проекту\\
                на тему:
            }
        }}

        \begin{parlines}{4}
            \centering\hugefont\textbf{\textit{\settings{textFields/doctitle}}}
        \end{parlines}
    \end{spacing}

    \vspace{1em}

    \begin{spacing}{2.5}
        \smallfont\textfieldShortRightDoubleLabel{
             Студент группы \settings{textFields/group}
        }{\smallfont\settings{textFields/student}}{\tinyfont(Подпись, дата)}{\tinyfont(И.О.Фамилия)}

        \smallfont\textfieldShortRightDoubleLabel{\smallfont Руководитель курсового проекта}{\smallfont\settings{textFields/prof}}{\tinyfont(Подпись, дата)}{\tinyfont(И.О.Фамилия)}
    \end{spacing}

    \clearpage
}
