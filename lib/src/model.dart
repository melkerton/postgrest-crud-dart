import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:postgrest_crud/postgrest_crud.dart';

abstract class Model<T> {
  String get modelName;
  String get primaryKey;
  Database database;
  http.StreamedResponse? response;

  // converters
  JsonObject toJson(T model);
  T fromJson(JsonObject jsonObject);

  // commom prefer
  final PostgrestPrefer preferRepresentation = {'return': 'representation'};

  // constructors
  Model({required this.database});

  // crud operations
  Future<Response<T>> create(T model) async {
    final body = payloadAsString(model);
    final response = await database.post(
        modelName: modelName, prefer: preferRepresentation, body: body);
    final models = await responseToModels(response);
    return Response<T>(response: response, models: models);
  }

  Future<Response<T>> createBatch(List<T> modelList) async {
    final body = payloadAsString(modelList);
    final response = await database.post(
        modelName: modelName, prefer: preferRepresentation, body: body);
    final models = await responseToModels(response);
    return Response<T>(response: response, models: models);
  }

  Future<Response<T>> recall({Query? query}) async {
    final PostgrestPrefer prefer = {'count': 'exact'};
    final response = await database.get(modelName: modelName, prefer: prefer);
    final models = await responseToModels(response);
    return Response<T>(response: response, models: models);
  }

  Future<Response<T>> update(T model) async {
    final jsonObject = toJson(model);
    assert(jsonObject.containsKey(primaryKey),
        "PrimaryKey `$primaryKey` not found in model!");

    final body = payloadAsString(jsonObject);
    final query = Query("?$primaryKey=eq.${jsonObject[primaryKey]}");
    final response = await database.put(
        modelName: modelName,
        body: body,
        query: query,
        prefer: preferRepresentation);
    final models = await responseToModels(response);
    return Response<T>(response: response, models: models);
  }

  void updateBatch(List<T> models) {
    // DatabasePrefer prefer = {'resolution': 'ignore-duplicates'};
  }

  void updatePartial(JsonObject jsonObject) {}

  Future<Response<T>> delete(T model) async {
    final jsonObject = toJson(model);
    assert(jsonObject.containsKey(primaryKey),
        "PrimaryKey `$primaryKey` not found in model!");

    final query = Query("?$primaryKey=eq.${jsonObject[primaryKey]}");
    final response = await database.delete(
        modelName: modelName, query: query, prefer: preferRepresentation);
    final models = await responseToModels(response);
    return Response<T>(response: response, models: models);
  }

  void deleteBatch(List<int> idSet) {}

  // helpers
  String payloadAsString(dynamic payload) {
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

  Future<List<T>> responseToModels(http.StreamedResponse response) async {
    this.response = response;
    List<T> list = [];
    final jsonList = await response.jsonObject;

    for (final obj in jsonList) {
      list.add(fromJson(obj));
    }

    return list;
  }
}
