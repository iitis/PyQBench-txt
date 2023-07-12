rev = $(shell git describe --abbrev=0 --tags)

pdf:
	@echo "Compiling PDF file..."
	latexmk -pdf -synctex=1 -aux-directory=../build -output-directory=../build -cd ./txt/supplemental.tex
	latexmk -pdf -synctex=1 -output-directory=../build -cd ./txt/manuscript_short.tex
response:
	@echo "Compiling response"
	latexmk -pdf -synctex=1 -output-directory=../../../../build -cd ./reviews/softwarex/reviews_1/response/response.tex
clean:
	@echo "Removing build directory if it exists..."
	rm -rf ./build
diff:
	@echo "Parsing git revision..."
	git rev-parse ${rev}
	@echo "Creating diff with revision ${rev}"
	@$(eval MY_MANUSCRIPT_DIFF_FILE_NAME :=  "${rev}-manuscript-diff.tex")
	@$(eval ORIGINAL_MANUSCRIPT_DIFF_FILE_NAME :=  "manuscript_short-diff${rev}.tex")
	@$(eval MY_SUPPLEMENTAL_DIFF_FILE_NAME :=  "${rev}-supplemental-diff.tex")
	@$(eval ORIGINAL_SUPPLEMENTAL_DIFF_FILE_NAME :=  "supplemental-diff${rev}.tex")
	latexdiff-vc -r ${rev} txt/manuscript_short.tex
	latexdiff-vc -r ${rev} txt/supplemental.tex
	mv "./txt/$(ORIGINAL_MANUSCRIPT_DIFF_FILE_NAME)" "./txt/$(MY_MANUSCRIPT_DIFF_FILE_NAME)"
	mv "./txt/$(ORIGINAL_SUPPLEMENTAL_DIFF_FILE_NAME)" "./txt/$(MY_SUPPLEMENTAL_DIFF_FILE_NAME)"
	@echo "Building pdfs with differences"
	latexmk -pdf -synctex=1 -output-directory=../build -cd ./txt/$(MY_MANUSCRIPT_DIFF_FILE_NAME)
	latexmk -pdf -synctex=1 -output-directory=../build -cd ./txt/$(MY_SUPPLEMENTAL_DIFF_FILE_NAME)
	mv "./txt/$(MY_MANUSCRIPT_DIFF_FILE_NAME)" ./build
	mv "./txt/$(MY_SUPPLEMENTAL_DIFF_FILE_NAME)" ./build
