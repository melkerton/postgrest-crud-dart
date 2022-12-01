import 'package:http/http.dart' as http;
//import 'package:postgrest_crud/postgrest_crud.dart';

class PostgrestCrudException implements Exception {
  @override
  String message;
  http.StreamedResponse? response;
  PostgrestCrudException(this.message, {this.response});

  @override
  String toString() {
    return message;
  }
}
