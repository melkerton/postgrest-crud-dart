@Tags(['model'])
import 'package:test/test.dart';

import '../../example/example.dart';

import '../setup.dart';

void main() {
  setUp(runSetup);
  test('ModelCreate', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1}]');
    final todoService = TodoModel(database: testDatabase);
    final model = Todo();
    final response = await todoService.create(model);
    expect(response.models.isNotEmpty, equals(true));
    expect(response.models.first.id, equals(1));
  });

  test('ModelCreateBatch', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1}, {"id":2}]');
    final todoService = TodoModel(database: testDatabase);
    final models = [Todo(), Todo()];
    final response = await todoService.createBatch(models);
    expect(response.models.isNotEmpty, equals(true));
    expect(response.models.length, equals(2));
    expect(response.models.first.id, equals(1));
    expect(response.models[1].id, equals(2));
  });

  test('ModelRecall', () async {
    testDatabase.httpClient = testMockClient(
        body: '[{"id":1}, {"id":2}]', headers: {"Content-Range": "0-1/20"});
    final todoService = TodoModel(database: testDatabase);
    final response = await todoService.recall();

    expect(response.models.isNotEmpty, equals(true));
    expect(response.models.length, equals(2));
    expect(response.count, equals(20));

    // reflects what is in response not what was set in request
    expect(response.limit, equals(2));
    expect(response.offset, equals(0));

    for (final m in response.models) {
      expect(m.id, isNotNull);
    }
  });

  test('ModelUpdateModel', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1}]');
    final todoService = TodoModel(database: testDatabase);
    final model = Todo(id: 1);
    final response = await todoService.update(model);
    expect(response.models.isNotEmpty, equals(true));
  });

  test('ModelUpdateModelList', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1}]');
    final todoService = TodoModel(database: testDatabase);
  });

  test('ModelUpdateJsonObject', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1}]');
    final todoService = TodoModel(database: testDatabase);
  });

  test('ModelDeleteModel', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1}]');
    final todoService = TodoModel(database: testDatabase);
  });

  test('ModelDeleteModelList', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1}]');
    final todoService = TodoModel(database: testDatabase);
  });

  test('ModelDeleteIdSet', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1}]');
    final todoService = TodoModel(database: testDatabase);
  });
}
