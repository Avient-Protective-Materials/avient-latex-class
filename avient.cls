
%% ===============================================================
%% avient.cls -- Corporate document class
%% Style variant: apm-report  |  v0.7.4  (2025-08-29)
%% Maintainer: Matthias Arras
%% ===============================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{avient}[2025/08/28 v0.7.4 Avient corporate class]

% ---------- Base class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt,a4paper]{article}

% ---------- Packages
\RequirePackage[a4paper,margin=20mm,headheight=24mm,top=5mm,headsep=5mm,includehead]{geometry}
\RequirePackage{graphicx}
\RequirePackage{array,tabularx}
\RequirePackage{ragged2e}
\RequirePackage{titlesec}
\RequirePackage{ifxetex,ifluatex,iftex}
\RequirePackage{xcolor}
\RequirePackage{xstring}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{parskip}
\RequirePackage{enumitem}
\RequirePackage{hyperref}
\RequirePackage{etoolbox}
% ---------- Fonts (prefer distro package; Light as default)
% If the FiraSans package is installed, use it for all engines.
\IfFileExists{FiraSans.sty}{%
  % Light = regular weight, Bold = bold weight; make sans the main family
  \RequirePackage[sfdefault,light]{FiraSans}
  % Optional tweaks you can add to the line above:
  %   ,semibold    -> makes \bfseries = SemiBold instead of Bold
  %   ,lining      -> use lining figures instead of oldstyle
  %   ,tabular     -> tabular (monospaced) figures
}{%
  % Fallbacks if the package isn't installed:
  \ifPDFTeX
    % pdfLaTeX: use Helvetica as a last resort
    \RequirePackage[scaled=0.95]{helvet}
    \renewcommand{\familydefault}{\sfdefault}
    \ClassWarning{avient}{FiraSans package not found; using Helvetica.}
  \else
    % Xe/Lua: try to load system Fira Sans Light via fontspec
    \RequirePackage{fontspec}
    \defaultfontfeatures{Ligatures=TeX}
    \IfFontExistsTF{Fira Sans Light}{%
      \setmainfont{Fira Sans Light}[
        ItalicFont     = Fira Sans Light Italic,
        BoldFont       = Fira Sans Bold,
        BoldItalicFont = Fira Sans Bold Italic
      ]
      \setsansfont{Fira Sans Light}[
        ItalicFont     = Fira Sans Light Italic,
        BoldFont       = Fira Sans Bold,
        BoldItalicFont = Fira Sans Bold Italic
      ]
      \renewcommand{\familydefault}{\sfdefault}
    }{%
      \RequirePackage[scaled=0.95]{helvet}
      \renewcommand{\familydefault}{\sfdefault}
      \ClassWarning{avient}{Fira Sans Light not found; using Helvetica.}
    }%
  \fi
}
% ---------- Colors (corporate palette)
\definecolor{brandmain}{HTML}{2A7DE1}   % main blue
\definecolor{brandlight}{HTML}{51D4FF}  % light accent
\definecolor{branddark}{HTML}{003478}   % dark accent
\definecolor{lightgray}{gray}{0.90}
\colorlet{brandblue}{brandmain} % back-compat

\newcommand{\setbrandmain}[1]{\definecolor{brandmain}{HTML}{#1}\colorlet{brandblue}{brandmain}}
\newcommand{\setbrandlight}[1]{\definecolor{brandlight}{HTML}{#1}}
\newcommand{\setbranddark}[1]{\definecolor{branddark}{HTML}{#1}}

\hypersetup{colorlinks=true, linkcolor=brandmain, urlcolor=brandmain, citecolor=brandmain, pdfauthor={}, pdftitle={}}

% ---------- Internal state
\newcommand{\apm@title}{}
\newcommand{\apm@subtitle}{}
\newcommand{\apm@authorname}{}
\newcommand{\apm@reviewer}{}
\newcommand{\apm@to}{}
\newcommand{\apm@cc}{}
\newcommand{\apm@docid}{}
\newcommand{\apm@docdate}{\today}
\newcommand{\apm@confidential}{}
\newcommand{\apm@companyname}{Avient Protective Materials Services B.V.}
\newcommand{\apm@companyaddress}{Chemelot Gate 2\\Building 200\\Urmonderbaan 22\\6167 RD Geleen\\The Netherlands}
\newcommand{\apm@logo}{brand/avient-logo.pdf} % PDF or PNG

% ---------- User-facing setters
\renewcommand{\title}[1]{\gdef\apm@title{#1}}
\newcommand{\subtitle}[1]{\gdef\apm@subtitle{#1}}
\renewcommand{\author}[1]{\gdef\apm@authorname{#1}}
\newcommand{\setreviewer}[1]{\gdef\apm@reviewer{#1}}
\newcommand{\setto}[1]{\gdef\apm@to{#1}}
\newcommand{\setcc}[1]{\gdef\apm@cc{#1}}
\newcommand{\setdocid}[1]{\gdef\apm@docid{#1}}
\renewcommand{\date}[1]{\gdef\apm@docdate{#1}}
\newcommand{\setconfidential}[1]{\gdef\apm@confidential{#1}}
\newcommand{\setcompanyname}[1]{\gdef\apm@companyname{#1}}
\newcommand{\setcompanyaddress}[1]{\gdef\apm@companyaddress{#1}}
\newcommand{\setcompanylogo}[1]{\gdef\apm@logo{#1}}

% ---------- Utilities
\newcommand{\apmStack}[1]{%
  \begingroup\StrSubstitute{#1}{;}{\\}[\apm@tmp]\apm@tmp\endgroup
}

% ---------- Header/Footer
\pagestyle{fancy}
\fancyhf{}
\newcommand{\HeaderLogoBlock}{%
  \begin{minipage}[b]{0.40\textwidth}
    \raggedleft
    \ifx\apm@confidential\empty\else
      {\small \textcolor{gray}{\textsc{\apm@confidential}} \par}\vspace{2mm}%
    \fi
    \IfFileExists{\apm@logo}{\includegraphics[height=13mm]{\apm@logo}}{}%
  \end{minipage}%
}
\fancyhead[R]{\HeaderLogoBlock}
\fancyfoot[R]{\small Page~\textbar~{\color{brandmain}\thepage{}}}
\renewcommand{\headrulewidth}{0pt}

% ---------- Plain pagestyle (no logo, but still confidential + page num)
\fancypagestyle{plain}{%
  \fancyhf{} % clear
  \fancyhead[R]{%
    \ifx\apm@confidential\empty\else
      {\small \textcolor{gray}{\textsc{\apm@confidential}} \par}\vspace{2mm}%
    \fi
  }
  \fancyfoot[R]{\small Page~\textbar~{\color{brandmain}\thepage{}}}
  \renewcommand{\headrulewidth}{0pt}
}

% ---------- Section heading style
% Numbered sections
\setcounter{secnumdepth}{3} % ensure sections/subsections are numbered (article default is 3)

\titleformat{\section}
  {\Large\bfseries\color{brandmain}} % format
  {\thesection}                      % label -> restore numbering
  {0.6em}                            % sep between number and title
  {}                                 % before-code

\titlespacing*{\section}{0pt}{1.5ex plus 1ex minus .2ex}{0.5ex}

% (Optional) numbered subsections in dark accent
\titleformat{\subsection}
  {\large\bfseries\color{branddark}}
  {\thesubsection}
  {0.5em}
  {}

\titlespacing*{\subsection}{0pt}{1.0ex plus .6ex minus .2ex}{0.4ex}

% Match styling for *unnumbered* \section* (used by Executive summary)
\titleformat{name=\section,numberless}
  {\Large\bfseries\color{brandmain}}
  {}{0pt}{}

% ---------- Title block
\newcommand{\TopStrut}{\rule{100pt}{0pt}\vspace{-1.0em}} % height only, zero width
\newcommand{\apm@maketitle}{%
  \noindent
  \begin{minipage}[t]{0.575\textwidth}
    \TopStrut\par
    \raggedright
    {\bfseries\fontsize{22}{26}\selectfont \apm@title\par}
    \ifdefempty{\apm@subtitle}{}{\vspace{3pt}{\itshape\Large \apm@subtitle\par}}
  \end{minipage}\hfill
  \begin{minipage}[t]{0.40\textwidth}
    \TopStrut\par
    {\raggedright
    {\apm@companyname\par}
    {\apm@companyaddress\par}}
  \end{minipage}

  \vspace{1.0em}

  \noindent
  \begin{minipage}[t]{0.575\textwidth}
    \raggedright
    {\textbf{From:}}\par \apmStack{\apm@authorname}\par\vspace{0.3em}
    \ifdefempty{\apm@reviewer}{}{{\itshape Reviewed by \apm@reviewer}\par\vspace{0.6em}}
  \end{minipage}\hfill
  \begin{minipage}[t]{0.4\textwidth}
    \raggedright
    {Date: \apm@docdate}\par\vspace{0.6em}
  \end{minipage}

  \vspace{0.8em}
  
  \noindent
  \begin{minipage}[t]{0.575\textwidth}
      \raggedright
        {\textbf{To:}}\par \apmStack{\apm@to}\par\vspace{1.2em}
        \textbf{\apm@docid}\par
  \end{minipage}\hfill
  \begin{minipage}[t]{0.4\textwidth}
    \raggedright
        {\textbf{Copy:}}\par \apmStack{\apm@cc}\par

  \end{minipage}
  \vspace{1.0em}
}



\renewcommand{\maketitle}{\thispagestyle{fancy}\apm@maketitle}

% ---------- Executive summary environment
\newenvironment{executivesummary}{%
  \section*{Executive summary}% styled via name=\section,numberless above
  % If you want it in the ToC, uncomment the next two lines:
  \phantomsection
  \addcontentsline{toc}{section}{Executive summary}%
}{}

% ---------- Style variant option
\newif\ifapmreport
\DeclareOption{apm-report}{\apmreporttrue}
\ExecuteOptions{apm-report}
\ProcessOptions\relax

% ---------- End of class
