/// Support for doing something awesome.
///
/// More dartdocs go here.
library postgrest_crud;

export 'src/config.dart';
export 'src/database.dart';
export 'src/http.dart';
export 'src/model.dart';
export 'src/prefer.dart';
export 'src/query.dart';
export 'src/response.dart';
export 'src/typedef.dart';

class PostgrestCrudException implements Exception {
  PostgrestCrudException();
}
