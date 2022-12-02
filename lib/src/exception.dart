import 'package:http/http.dart' as http;
//import 'package:postgrest_crud/postgrest_crud.dart';

/// An exception caused by an error in a pkg. `IN DEV`.
class PostgrestCrudException implements Exception {
  String message;

  /// A response (if any) associated with this exception.
  http.StreamedResponse? response;
  PostgrestCrudException(this.message, {this.response});

  @override
  String toString() {
    return message;
  }
}
