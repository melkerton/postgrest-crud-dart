export 'src/todo_model.dart';
import 'src/todo_model.dart';
import 'dart:io';
import 'package:yaml/yaml.dart';

import 'package:postgrest_crud/postgrest_crud.dart';

void main() async {
  // gather config as needed
  final configString = File('example/config.yaml').readAsStringSync();
  final configYaml = loadYaml(configString);

  /// build postgrest config, optional bearerToken
  final PostgrestConfig postgrestConfig = PostgrestConfig(
      url: configYaml['postgrest']['url'],
      schema: configYaml['postgrest']['schema']);

  // create a connection to get model connections
  final connection = Connection(postgrestConfig: postgrestConfig);

  // the main service provides CRUD ops for todo table to postgrest api via Connection
  final service = TodoClient(connection: connection);

  // get some results
  final response = await service.recall(query: Query("?id=gte.0"));

  for (final model in response.models) {
    print('${model.id}\t${model.item}\t\t${model.details ?? "No details"}');
  }

  // close httpClient when finished all requests
  // simply closes the http.Client
  // otherwise http.Client will hang until Keep-Alive? timeout triggers
  connection.close();
}
