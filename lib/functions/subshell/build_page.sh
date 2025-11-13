#!/bin/bash
#############
# DESCRIPTION
#############
# Builds a page from a source .md file and outputs the built version to "$output_name" in the same directory
#
#############
# Usage: 
# build_page source.md [output.html]

build_page() (

# Switch to page directory
page=$(basename "$1")
output_name=${2:-"index.html"}
cd $(dirname "$1")

get_page_metadata $page

if [[ $is_toc == "true" ]]; then
        build_toc "$page"
elif [[ $process_markdown == "false" ]]; then
        build_header "$output_name"
        cat $page | sed -e '1,/END ARISE/d' | cat >> "$output_name"
        build_footer "$output_name"
else
        build_header "$output_name"
        # Grab everything after the Arise metadata block, run it through pandoc to convert to html, and append to our file in progress
        cat $page | sed -e '1,/END ARISE/d' | pandoc -f markdown -t html >> "$output_name"
        build_footer "$output_name"
fi

# Inline Evaluations - DISABLED, WIP, ENABLE AT YOUR OWN PERIL
# evaluate_inline "$output_name"
)
