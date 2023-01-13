import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:postgrest_crud/postgrest_crud.dart';

/// Handles direct interaction with Postgrest API.
///
/// Provides typical http methods primarily used by `Client`.
class Connection {
  /// Postgrest connection parameters.
  final PostgrestConfig postgrestConfig;

  /// The `http.Client` to use for requests.
  final http.Client httpClient;

  /// Builds a connection with config parameters and optional `http.Client`.
  ///
  /// Setting `httpClient` is useful for providing an `http.MockClient` for testing.
  Connection({required this.postgrestConfig, http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  /// Closes the current `http.Client`.
  void close() {
    httpClient.close();
  }

  /// Sends an HTTP DELETE request with given request parameters.
  Future<http.StreamedResponse> delete(
      {required String modelName,
      Query? query,
      PostgrestPrefer? prefer}) async {
    return sendRequest(
        method: HttpMethod.delete,
        modelName: modelName,
        query: query,
        prefer: prefer);
  }

  /// Sends an HTTP GET request with given request parameters.
  Future<http.StreamedResponse> get(
      {required String modelName,
      Query? query,
      PostgrestPrefer? prefer}) async {
    return sendRequest(
        method: HttpMethod.get,
        modelName: modelName,
        query: query,
        prefer: prefer);
  }

  /// Sends an HTTP HEAD request with given request parameters.
  Future<http.StreamedResponse> head(
      {required String modelName,
      Query? query,
      PostgrestPrefer? prefer}) async {
    return sendRequest(
        method: HttpMethod.head,
        modelName: modelName,
        query: query,
        prefer: prefer);
  }

  /// Sends an HTTP PATCH request with given request parameters.
  Future<http.StreamedResponse> patch(
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

  /// Sends an HTTP POST request with given request parameters.
  Future<http.StreamedResponse> post(
      {required String modelName,
      required String body,
      PostgrestPrefer? prefer}) async {
    return sendRequest(
        method: HttpMethod.post,
        modelName: modelName,
        prefer: prefer,
        body: body);
  }

  /// Sends an HTTP PUT request with given request parameters.
  Future<http.StreamedResponse> put(
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

  /// Send an rpc command with arguments.
  ///
  /// See [Stored Procedures](https://postgrest.org/en/stable/api.html#stored-procedures)
  Future<dynamic> rpc(
      {required String function,
      required Map<String, dynamic> arguments}) async {
    final response = await sendRequest(
        method: HttpMethod.post,
        modelName: "rpc/$function",
        body: json.encode(arguments));
    return json.decode(await response.bodyToString);
  }

  /// Builds and sends the final request, returning a Future http.StreamedResponse.
  Future<http.StreamedResponse> sendRequest(
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
    var request = http.Request(method.name, Uri.parse(url));

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

    // body
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = body;
    }

    return httpClient.send(request);
  }
}
