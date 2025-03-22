
push:
	@git config credential.helper 'cache --timeout=3600'
	@git add .
	@git commit -am "Update" || true
	@git push
