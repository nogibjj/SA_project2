install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:
	# No python scripts to test

format:
	# black *.py

lint:
	# No python scripts to lint

container-lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

refactor: format lint

all: install lint test