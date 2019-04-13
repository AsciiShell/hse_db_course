for entry in `ls ./main*.tex`
do
  xelatex -synctex=1 -interaction=nonstopmode $entry
  xelatex -synctex=1 -interaction=nonstopmode $entry
done
exit 0