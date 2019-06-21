VERSION=$(shell python3 -c "import pyfma; print(pyfma.__version__)")

default:
	@echo "\"make publish\"?"

tag:
	@if [ "$(shell git rev-parse --abbrev-ref HEAD)" != "master" ]; then exit 1; fi
	@echo "Tagging v$(VERSION)..."
	git tag v$(VERSION)
	git push --tags

upload: setup.py
	# Make sure we're on the master branch
	@if [ "$(shell git rev-parse --abbrev-ref HEAD)" != "master" ]; then exit 1; fi
	rm -rf dist/*
	python3 setup.py sdist
	twine upload dist/*.tar.gz
	# HTTPError: 400 Client Error: Binary wheel 'pygalmesh-0.2.0-cp27-cp27mu-linux_x86_64.whl' has an unsupported platform tag 'linux_x86_64'. for url: https://upload.pypi.org/legacy/
	# python3 setup.py bdist_wheel --universal
	# twine upload dist/*.whl

publish: tag upload

clean:
	@find . | grep -E "(__pycache__|\.pyc|\.pyo$\)" | xargs rm -rf
	@rm -rf *.egg-info/ build/ dist/

format:
	isort -rc .
	black setup.py pyfma/ test/*.py

lint:
	black --check setup.py pyfma/ test/*.py
	flake8 setup.py pyfma/ test/*.py
