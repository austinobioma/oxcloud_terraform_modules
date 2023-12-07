.PHONY: bootstrap tf/fmt tf/lint tf/ci tf/checkov tf/docs docker/build

tf/ci: docker/build
	docker run -v $(shell pwd):/data --rm oxcloud/terraform run --hook-stage push

tf/ci/all: docker/build
	docker run -v $(shell pwd):/data --rm oxcloud/terraform run --hook-stage push --all-files

tf/checkov: docker/build
	docker run -v $(shell pwd):/data --rm oxcloud/terraform run --hook-stage push checkov

tf/checkov/all: docker/build
	docker run -v $(shell pwd):/data --rm oxcloud/terraform run --hook-stage push checkov --all-files

tf/docs: docker/build
	docker run -v $(shell pwd):/data --rm oxcloud/terraform run --hook-stage push terraform_docs_replace

tf/fmt: docker/build
	docker run -v $(shell pwd):/data --entrypoint /bin/terraform --rm oxcloud/terraform fmt -recursive

tf/lint: docker/build
	docker run -v $(shell pwd):/data --rm oxcloud/terraform run tflint

docker/build:
	docker build -t oxcloud/terraform -f jenkins/build.dockerfile .