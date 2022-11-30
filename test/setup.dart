import 'dart:io';

import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:postgrest_crud/postgrest_crud.dart';

void runSetup() {}

final testPostgrestConfig = PostgrestConfig(
    url: "http://localhost", schema: "test", bearerToken: "TOKEN");

final testDatabase = Database(postgrestConfig: testPostgrestConfig);

MockClient testMockClient(
    {Function? preResponse,
    Function? response,
    String? body,
    int? statusCode,
    Map<String, String>? headers}) {
  final mockClient = MockClient((request) async {
    if (preResponse is Function) preResponse(request);
    if (response is Function) return response(request);
    return http.Response(
        request: request,
        body ?? '[]',
        statusCode ?? 200,
        headers: headers ?? {});
  });
  return mockClient;
}
