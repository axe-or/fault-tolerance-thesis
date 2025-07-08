
set -eu

TrashFiles(){
	find .  -name '*.aux' \
		-or -name '*.log' \
		-or -name '*.loq' \
		-or -name '*.loe' \
		-or -name '*.bbl' \
		-or -name '*.blg' \
		-or -name '*.lof' \
		-or -name '*.toc'
}

files="$(TrashFiles)"

for f in $files; do
	echo "Delete $f"
	rm -f "$f"
done

