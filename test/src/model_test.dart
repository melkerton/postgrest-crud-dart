@Tags(['model'])
import 'package:test/test.dart';
import 'package:postgrest_crud/postgrest_crud.dart';
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
    testDatabase.httpClient = testMockClient(body: '[{"id":1},{"id":2}]');
    final todoService = TodoModel(database: testDatabase);

    final models = [Todo(), Todo()];
    final response = await todoService.updateBatch(models);
    expect(response.models.isNotEmpty, equals(true));
  });

  test('ModelUpdateJsonObject', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1}]');
    final todoService = TodoModel(database: testDatabase);
    final partialModel = {"id": 1};
    final response = await todoService.updatePartial(partialModel);
    expect(response.models.isNotEmpty, equals(true));
  });

  test('ModelDeleteModel', () async {
    testDatabase.httpClient =
        testMockClient(body: '', headers: {'Content-Range': '*/1'});
    final todoService = TodoModel(database: testDatabase);

    final model = Todo(id: 1);
    final response = await todoService.delete(model);
    expect(response.count, equals(1));
  });

  test('ModelDeleteBatch', () async {
    testDatabase.httpClient =
        testMockClient(body: '', headers: {'Content-Range': '*/2'});
    final todoService = TodoModel(database: testDatabase);

    final response = await todoService.deleteBatch(Query("?id=in.[1,2,3]"));
    expect(response.count, equals(2));
  });
}
