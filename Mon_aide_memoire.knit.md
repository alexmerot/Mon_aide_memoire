--- 
title: "Aide-mémoire : Statistiques, Visualisation des données & Système d'Information Géographique"
author: "Alexis Mérot"
date: "Modifié le : 2020-07-18"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
description: "Description"
---

# Prerequisites

This is a _sample_ book written in **Markdown**. You can use anything that Pandoc's Markdown supports, e.g., a math equation $a^2 + b^2 = c^2$.

The **bookdown** package can be installed from CRAN or Github:


```r
install.packages("bookdown")
# or the development version
# devtools::install_github("rstudio/bookdown")
```

Remember each Rmd file contains one and only one chapter, and a chapter is defined by the first-level heading `#`.

To compile this example to PDF, you need XeLaTeX. You are recommended to install TinyTeX (which includes XeLaTeX): <https://yihui.org/tinytex/>.



<!--chapter:end:index.Rmd-->

# R Markdown

## Pourquoi R Markdown ?

R Markdown est un format de fichier (à l'extension `.Rmd`) fournissant un cadre
de création pour faire des rapports scientifiques automatisés. Ces documents
peuvent ainsi être totalement reproductibles et plusieurs formats de rendu
finale (statiques ou dynamiques) sont supportés.

Le fichier est écrit via le langage Markdown et des sections de code R peuvent y
être insérées facilement (ainsi que du code écrit via d'autres langages tels
que Python ou SQL). Cela offre une syntaxe facile à lire et à écrire tout en
permettant de générer un rapport structuré et élégant.

Pour que cela fonctionne, R Markdown est lié à deux packages : `knitr` et le
convertisseur universel de document `pandoc`.  
Le package `knitr` permet la création, à partir du fichier `.Rmd`, d'un fichier
au format `md` contenant le code et sa sortie. Ce fichier est alors converti
dans le format voulu de rendu final via `pandoc` (`.html`, `.pdf`, etc.).

![*Source : <https://rmarkdown.rstudio.com/lesson-2.html>*](image/rmarkdownflow.png)

Toutes mes notes seront donc écrites via R Markdown, et cette section intégrera
tous les tips intéressants que je rencontre au fur et à mesure des besoins 
pendant l'écriture de ma auto-formation.

<!--chapter:end:01-R-Markdown.Rmd-->

# Statistique

<!--chapter:end:02-Statistique.Rmd-->

# Système d''Information Géographique

<!--chapter:end:03-SIG.Rmd-->

