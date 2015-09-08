#!/bin/sh
#clears test directories I created
. vars.sh
for dest in ${dests[@]}; do
  find "$dest" -depth -type f -name '*' -exec bash -c '
      for file do
        rm "$file"
      done
  ' bash {} +
  find "$dest" -depth -type f -name '*' -exec bash -c '
      for dir do
        rmdir "$dir"
      done
  ' bash {} +
done


