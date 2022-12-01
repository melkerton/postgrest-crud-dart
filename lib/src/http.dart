import 'dart:convert';

import 'package:http/http.dart';

import 'package:postgrest_crud/postgrest_crud.dart';

typedef HttpParam = Map<String, String>;
typedef HttpHeader = Map<String, String>;

enum HttpMethod { delete, get, head, patch, post, put }

// used in Model
extension HttpResponseDecoder on StreamedResponse {
  Future<List<JsonObject>> get jsonObject async {
    List<JsonObject> list = [];
    var payload = await stream.bytesToString();
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
