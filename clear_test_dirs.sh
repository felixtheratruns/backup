#!/bin/sh
#clears test directories I created
. vars.sh
for dest in ${dests[@]}; do
  find "$dest" -mindepth 1 -type f -name '*' -exec bash -c '
      for file do
        rm -v "$file"
      done
  ' bash {} +
  find "$dest" -mindepth 1 -type d -name '*' -exec bash -c '
      for dir do
        rmdir -v "$dir"
      done
  ' bash {} +
done
