import 'dart:convert';

import 'package:http/http.dart';

import 'package:postgrest_crud/postgrest_crud.dart';

/// Http method constants.
enum HttpMethod { delete, get, head, patch, post, put }

/// Preprocesses an http.StreamedResponse.
///
/// Converts body string to `List<JsonObject>` if non-empty.
extension HttpResponseDecoder on StreamedResponse {
  /// Consumes the response stream and returns a `String`.
  Future<String> get bodyToString async {
    return await stream.bytesToString();
  }

  /// Converts the response body `String` to a json object.
  Future<List<JsonObject>> jsonObject(String payload) async {
    List<JsonObject> list = [];
    if (payload.isEmpty) {
      return list;
    }

    var data = json.decode(payload);
    if (data is! List) data = [data];

    for (final d in data) {
      list.add(d as JsonObject);
    }

    return list;
  }
}
