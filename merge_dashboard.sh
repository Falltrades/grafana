#!/bin/bash
set -e

json_dashboard1=${1} 
json_dashboard2=${2}
output_file=merge_result.json

# Find the line number containing the first pattern in json_dashboard1.
line_number=$(grep -n "panels" "${json_dashboard1}" | head -n 1 | cut -d ":" -f 1)

# Generate the merge dashboard, adding the head of json_dashboard1.
head -n ${line_number} ${json_dashboard1} > ${output_file}

# Add the content between panels and refresh from json_dashboard2.
awk "/panels\": \[/,/"refresh"/" ${json_dashboard2} | sed "1d; \$d" | sed "\$d" | sed "\$s/.\$/&,/" >> ${output_file}

# Add the remaining content from json_dashboard1.
tail -n +"$((line_number+1))" ${json_dashboard1} >> ${output_file}
