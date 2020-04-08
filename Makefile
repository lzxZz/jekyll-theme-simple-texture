.PHONY : run release push


run:
	jekyll server

release:
	jekyll build
	cd gitpages  &&	pwd


push:
	git add .
	git commit -m "push提交时间:`date +%Y-%m-%d-%02k-%M`"
	echo 提交时间:`date +%Y-%m-%d-%02k-%M`
