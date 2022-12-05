analyze:
	dart analyze lib/src/*


doc:
	dart doc

pana:
	pana --no-warning .
	
publish:
	dart pub publish

publish-dry-run:
	dart pub publish --dry-run

test:
	dart test

test-example:
	nodemon -x 'dart test example/test/example_test.dart' -e 'dart'

test-query:
	nodemon -x 'dart test -t query' -e 'dart'

test-watch:
	nodemon -x 'dart test' -e 'dart'

.PHONY: test doc