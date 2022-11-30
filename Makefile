test:
	dart test

test-watch:
	nodemon -x 'dart test' -e 'dart'

publish:
	dart pub publish

.PHONY: test