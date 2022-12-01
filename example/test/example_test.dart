@Tags(['example'])
import 'package:yaml/yaml.dart';
import 'dart:io';
import 'package:test/test.dart';
import 'package:postgrest_crud/postgrest_crud.dart';
import '../src/todo_model.dart';

void main() {
  test('LiveCommunication', () async {
    // delete existing

    // recall expect count = 0

    // create
    final configString = File('example/config.yaml').readAsStringSync();
    final configYaml = loadYaml(configString);
    final PostgrestConfig postgrestConfig = PostgrestConfig(
        url: configYaml['postgrest']['url'],
        schema: configYaml['postgrest']['schema']);
    final Database database = Database(postgrestConfig: postgrestConfig);
    final service = TodoModel(database: database);
    var response = await service.recall();

    try {
      //final model = Todo(item: "Get cream!");
      //response = await service.create(model);
    } on PostgrestCrudException catch (e) {
      print(await e.response!.stream.bytesToString());
    }

    try {
      response = await service.recall(query: Query("?item=like.*cream*"));
      expect(response.models.length, 3);
      expect(response.count, response.models.length);
    } on PostgrestCrudException catch (e) {
      print(await e.response!.stream.bytesToString());
    }
  });
}
