import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:postgrest_crud/postgrest_crud.dart';

/// Handles Model interactions with Database.
abstract class Model<T> {
  /// Postgrest URL table slug. e.g. http://example.com/MODEL-NAME/
  String get modelName;

  /// Primary Key field of model table.
  String get primaryKey;
  final Database database;

  /// Holds the last response from Database.
  http.StreamedResponse? lastResponse;
  String? lastBody;

  // converters
  JsonObject toJson(T model);
  T fromJson(JsonObject jsonObject);

  // common prefer
  final PostgrestPrefer _preferRepresentation =
      PostgrestPrefer(returnValue: 'representation');

  // constructors
  Model({required this.database});

  // crud operations
  Future<Response<T>> create(T model) async {
    final body = _payloadAsString(model);
    final response = await database.post(
        modelName: modelName, prefer: _preferRepresentation, body: body);
    return _buildResponse(response);
  }

  Future<Response<T>> createBatch(List<T> modelList) async {
    final body = _payloadAsString(modelList);
    final response = await database.post(
        modelName: modelName, prefer: _preferRepresentation, body: body);
    return _buildResponse(response);
  }

  Future<Response<T>> recall({Query? query}) async {
    final PostgrestPrefer prefer = PostgrestPrefer(countValue: 'exact');
    final response =
        await database.get(modelName: modelName, query: query, prefer: prefer);
    return _buildResponse(response);
  }

  Future<Response<T>> update(T model) async {
    final jsonObject = toJson(model);
    assert(jsonObject.containsKey(primaryKey),
        "PrimaryKey `$primaryKey` not found in model!");

    final body = _payloadAsString(jsonObject);
    final query = Query("?$primaryKey=eq.${jsonObject[primaryKey]}");
    final response = await database.patch(
        modelName: modelName,
        body: body,
        query: query,
        prefer: _preferRepresentation);
    return _buildResponse(response);
  }

  /// Performs an upsert with resolution=ignore-duplicates
  Future<Response<T>> updateBatch(List<T> models) async {
    final body = _payloadAsString(models);
    PostgrestPrefer prefer = PostgrestPrefer(
        resolutionValue: 'merge-duplicates', returnValue: 'representation');
    final response =
        await database.post(modelName: modelName, body: body, prefer: prefer);
    return _buildResponse(response);
  }

  /// Updates a model from a partial JsonObject representation.
  /// Checks for primaryKey in jsonObject or requires a Query
  Future<Response<T>> updatePartial(JsonObject jsonObject,
      {Query? query}) async {
    final body = _payloadAsString(jsonObject);
    if (query != null) {
      assert(jsonObject.containsKey(primaryKey),
          "PrimaryKey `$primaryKey` not found in model!");
    }

    query = query ?? Query("?$primaryKey=eq.${jsonObject[primaryKey]}");
    final response = await database.patch(
        modelName: modelName,
        body: body,
        query: query,
        prefer: _preferRepresentation);
    return _buildResponse(response);
  }

  Future<Response<T>> delete(T model) async {
    final prefer = PostgrestPrefer(countValue: 'exact');
    final jsonObject = toJson(model);
    assert(jsonObject.containsKey(primaryKey),
        "PrimaryKey `$primaryKey` not found in model!");

    final query = Query("?$primaryKey=eq.${jsonObject[primaryKey]}");
    final response = await database.delete(
        modelName: modelName, query: query, prefer: prefer);
    return _buildResponse(response);
  }

  Future<Response<T>> deleteBatch(Query query) async {
    final prefer = PostgrestPrefer(countValue: 'exact');
    final response = await database.delete(
        modelName: modelName, query: query, prefer: prefer);
    return _buildResponse(response);
  }

  Future<Response<T>> _buildResponse(http.StreamedResponse response) async {
    if (response.statusCode < 200 || response.statusCode > 299) {
      throw PostgrestCrudException(
          "${response.reasonPhrase} (${response.statusCode})",
          response: response);
    }

    final models = await _responseToModels(response);
    return Response<T>(response: response, models: models);
  }

  // helpers
  String _payloadAsString(dynamic payload) {
    if (payload is JsonObject || payload is List<JsonObject>) {
      return json.encode(payload);
    } else if (payload is T) {
      return json.encode(toJson(payload));
    } else if (payload is List<T>) {
      return json.encode(payload.map((m) => toJson(m)).toList());
    } else {
      throw Error();
    }
  }

  Future<List<T>> _responseToModels(http.StreamedResponse response) async {
    lastResponse = response;
    List<T> list = [];
    final jsonList = await response.jsonObject;

    for (final obj in jsonList) {
      list.add(fromJson(obj));
    }

    return list;
  }
}
