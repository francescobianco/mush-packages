
update:
	@bash scripts/generate-readme.sh

push: update
	@git config credential.helper 'cache --timeout=3600'
	@git add .
	@git commit -am "Update" || true
	@git push
