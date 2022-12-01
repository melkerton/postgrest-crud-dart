import 'dart:core';

import 'package:http/http.dart';
import 'package:postgrest_crud/postgrest_crud.dart';

/// Handles direct interaction with Postgrest API.
class Database {
  final PostgrestConfig postgrestConfig;
  Client httpClient = Client();

  // constructor
  Database({required this.postgrestConfig});

  // http table methods
  Future<StreamedResponse> delete(
      {required String modelName,
      Query? query,
      PostgrestPrefer? prefer}) async {
    return sendRequest(
        method: HttpMethod.delete,
        modelName: modelName,
        query: query,
        prefer: prefer);
  }

  Future<StreamedResponse> get(
      {required String modelName,
      Query? query,
      PostgrestPrefer? prefer}) async {
    return sendRequest(
        method: HttpMethod.get,
        modelName: modelName,
        query: query,
        prefer: prefer);
  }

  Future<StreamedResponse> head(
      {required String modelName,
      Query? query,
      PostgrestPrefer? prefer}) async {
    return sendRequest(
        method: HttpMethod.head,
        modelName: modelName,
        query: query,
        prefer: prefer);
  }

  Future<StreamedResponse> patch(
      {required String modelName,
      required String body,
      Query? query,
      PostgrestPrefer? prefer}) async {
    return sendRequest(
        method: HttpMethod.patch,
        modelName: modelName,
        query: query,
        prefer: prefer,
        body: body);
  }

  Future<StreamedResponse> post(
      {required String modelName,
      required String body,
      PostgrestPrefer? prefer}) async {
    return sendRequest(
        method: HttpMethod.post,
        modelName: modelName,
        prefer: prefer,
        body: body);
  }

  Future<StreamedResponse> put(
      {required String modelName,
      required String body,
      Query? query,
      PostgrestPrefer? prefer}) async {
    return sendRequest(
        method: HttpMethod.put,
        modelName: modelName,
        query: query,
        prefer: prefer,
        body: body);
  }

  // rpc command
  void rpc() {}

  Future<StreamedResponse> sendRequest(
      {required HttpMethod method,
      required String modelName,
      Query? query,
      PostgrestPrefer? prefer,
      String? body}) async {
    // build request
    var url = "${postgrestConfig.url}/$modelName";
    if (query != null) {
      url = "$url${query.toString()}";
    }
    var request = Request(method.name, Uri.parse(url));

    //[Accept|Content]-Profile
    if ([HttpMethod.get, HttpMethod.head].contains(method)) {
      request.headers['Accept-Profile'] = postgrestConfig.schema;
    } else {
      request.headers['Content-Profile'] = postgrestConfig.schema;
    }

    // Prefer
    if (prefer != null) {
      request.headers['Prefer'] = prefer.toString();
    }

    // auth
    if (postgrestConfig.bearerToken != null) {
      request.headers['Authorization'] =
          "Bearer ${postgrestConfig.bearerToken}";
    }

    // application

    // body
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = body;
    }

    return httpClient.send(request);
  }
}
