@Tags(['example'])

import 'package:yaml/yaml.dart';
import 'dart:io';
import 'package:test/test.dart';
import 'package:postgrest_crud/postgrest_crud.dart';
import '../src/todo_model.dart';

void main() {
  late TodoModel service;
  late Query query;
  setUp(() {
    final configString = File('example/config.yaml').readAsStringSync();
    final configYaml = loadYaml(configString);
    final PostgrestConfig postgrestConfig = PostgrestConfig(
        url: configYaml['postgrest']['url'],
        schema: configYaml['postgrest']['schema']);
    service = TodoModel(database: Database(postgrestConfig: postgrestConfig));
    query = Query("?item=like.*cream*");
  });

  test('LiveCommunication', () async {
    // create
    try {
      final model = Todo(item: "Get cream!");
      Response response = await service.create(model);
      expect(response.models.first, isNotNull);
    } on PostgrestCrudException catch (e) {
      print(await e.response!.stream.bytesToString());
    }

    // recall + update + updatePartial
    try {
      // recall
      Response response = await service.recall(query: query);
      expect(response.models.length, equals(1));
      Todo model = response.models.first!;

      // update
      model.item = "cream and milk.";
      response = await service.update(model);
      expect(response.models.first, isNotNull);
      expect(response.models.first.item, "cream and milk.");

      // updatePartial
      JsonObject jsonObject = {'id': model.id, 'item': 'milk and cream.'};
      response = await service.updatePartial(jsonObject);
      expect(response.models.first, isNotNull);
      expect(response.models.first.item, "milk and cream.");
    } on PostgrestCrudException catch (e) {
      print(await e.response!.stream.bytesToString());
      print(e.response!.request!.headers);
    }

    // delete
    try {
      Response response = await service.deleteBatch(query);
      expect(response.models.isEmpty, equals(true));
    } on PostgrestCrudException catch (e) {
      print(await e.response!.stream.bytesToString());
    }
  });

  test('LiveCommunicationBatch', () async {
    // create
    try {
      final models = [Todo(item: "Get cream!")];
      Response response = await service.createBatch(models);
      expect(response.models.first, isNotNull);
    } on PostgrestCrudException catch (e) {
      print(await e.response!.stream.bytesToString());
    }

    // recall + update
    try {
      Response response = await service.recall(query: query);
      expect(response.models.length, equals(1));

      Todo model = response.models.first!;
      model.item = "cream and milk.";
      response = await service.updateBatch([model]);
      expect(response.models.first, isNotNull);
      expect(response.models.first.item, "cream and milk.");
    } on PostgrestCrudException catch (e) {
      print(await e.response!.stream.bytesToString());
      print(e.response!.request!.headers);
    }

    // delete
    try {
      Response response = await service.deleteBatch(query);
      expect(response.models.isEmpty, equals(true));
    } on PostgrestCrudException catch (e) {
      print(await e.response!.stream.bytesToString());
    }
  });
}
