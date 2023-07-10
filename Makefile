rev = $(shell git describe --abbrev=0 --tags)

pdf:
	@echo "Compiling PDF file..."
	latexmk -pdf -synctex=1 -output-directory=../build -cd ./txt/manuscript.tex
clean:
	@echo "Removing build directory if it exists..."
	rm -rf ./build
diff:
	@echo "Parsing git revision..."
	git rev-parse ${rev}
	@echo "Creating diff with revision ${rev}"
	@$(eval MY_DIFF_FILE_NAME :=  "${rev}-diff.tex")
	@$(eval ORIGINAL_DIFF_FILE_NAME :=  "manuscript-diff${rev}.tex")
	latexdiff-vc -r ${rev} txt/manuscript.tex
	mv "./txt/$(ORIGINAL_DIFF_FILE_NAME)" "./txt/$(MY_DIFF_FILE_NAME)"
	@echo "Building pdf with differences"
	latexmk -pdf -synctex=1 -output-directory=../build -cd ./txt/$(MY_DIFF_FILE_NAME)
	mv "./txt/$(MY_DIFF_FILE_NAME)" ./build
