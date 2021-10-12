#!/bin/bash
#
# convert_pandoc.sh
# -----------------
#
# Convert all found .markdown files to HTML and PDF via pandoc.

find . -maxdepth 1 -iname "*.markdown" | while read markdown_file; do
  # extract markdown file name w/o extension
  markdown_name=`echo "${markdown_file}" | sed 's/[\.\/]*\([^.]*\).*$/\1/g'`
  # convert markdown to html
  pandoc --css pandoc_stylesheet.css "${markdown_name}.markdown" -o "${markdown_name}.html"
  # convert markdown to pdf
  pandoc --template pandoc_template.tex "${markdown_name}.markdown" -o "${markdown_name}.pdf"
done

evince land_based_layers_workflow.pdf &
firefox land_based_layers_workflow.html &
