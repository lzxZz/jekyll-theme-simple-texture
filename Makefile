.PHONY : run release push


run:
	jekyll server

release:
	jekyll build
	cp _site/* gitpages/ -r
	cd gitpages  &&	git add . &&  git commit -m "push提交时间:`date +%Y-%m-%d-%02k-%M`" &&  git push pages master 
	echo "博客发布成功"


push:
	git add .
	git commit -m "push提交时间:`date +%Y-%m-%d-%02k-%M`"
	echo 提交时间:`date +%Y-%m-%d-%02k-%M`
	git push origin master
	echo "git上传成功"
