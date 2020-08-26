#!/bin/bash

parser=../rbgParser/bin/rbgParser

# Usage:
# regenerate ["options for parser"] [source_directory] [suffix]
# regenerate "-fnoop-before-alternative -fnoop-before-modifier" ../../rbgGames/games splitModPlus
function regenerate {
  echo "Parser arguments: $1"
  mkdir "$2/split"
  for gamefile in $2/*.rbg; do
    outfile="$2/split/$(basename "$gamefile" .rbg)_$3.rbg"
    echo "$gamefile -> $outfile"
    ${parser} $1 -o $outfile.tmp $gamefile
    echo "// $1" > $outfile
    sed 's|\.\+|\.|g' -i $outfile.tmp
    sed 's|\(\->[a-z]*\s\)\(\.\)|\1|g' $outfile.tmp >> $outfile
    rm $outfile.tmp
  done
}

regenerate "-fnoop-before-modifier -fnoop-before-alternative -fnoop-after-star" games splitModPlusStarChunk
regenerate "-fnoop-before-modifier -fnoop-before-alternative -fnoop-before-star" games splitModPlusStar
regenerate "-fnoop-before-modifier -fnoop-before-alternative" games splitModPlus
regenerate "-fnoop-before-modifier" games splitMod
regenerate "-fnoop-after-modifier -fnoop-before-alternative -fnoop-after-star" games splitAmodPlusStarChunk
regenerate "-fnoop-after-modifier -fnoop-before-alternative -fnoop-before-star" games splitAmodPlusStar
regenerate "-fnoop-after-modifier -fnoop-before-alternative" games splitAmodPlus
regenerate "-fnoop-after-modifier" games splitAmod
