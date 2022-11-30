doc:
	dart doc

publish:
	dart pub publish

test:
	dart test

test-watch:
	nodemon -x 'dart test' -e 'dart'

.PHONY: test doc