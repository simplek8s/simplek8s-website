publish:
	docker buildx build \
		--platform 'linux/amd64,linux/arm64' \
		--tag registry.jlsalvador.online/simplek8s/website \
		--push \
		.
