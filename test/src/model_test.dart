@Tags(['model'])
import 'package:test/test.dart';
import 'package:postgrest_crud/postgrest_crud.dart';

import '../setup.dart';
import '../mock.dart';

void main() {
  setUp(runSetup);
  test('ModelCreate', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1}]');
    final service = MockClassModel(database: testDatabase);
    final model = MockClass();
    final response = await service.create(model);
    expect(response.models.isNotEmpty, equals(true));
    expect(response.models.first.id, equals(1));
  });

  test('ModelCreateBatch', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1}, {"id":2}]');
    final service = MockClassModel(database: testDatabase);
    final models = [MockClass(), MockClass()];
    final response = await service.createBatch(models);
    expect(response.models.isNotEmpty, equals(true));
    expect(response.models.length, equals(2));
    expect(response.models.first.id, equals(1));
    expect(response.models[1].id, equals(2));
  });

  test('ModelRecall', () async {
    testDatabase.httpClient = testMockClient(
        body: '[{"id":1}, {"id":2}]', headers: {"Content-Range": "0-1/20"});
    final service = MockClassModel(database: testDatabase);
    final response = await service.recall();

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
    final service = MockClassModel(database: testDatabase);
    final model = MockClass(id: 1);
    final response = await service.update(model);
    expect(response.models.isNotEmpty, equals(true));
  });

  test('ModelUpdateModelList', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1},{"id":2}]');
    final service = MockClassModel(database: testDatabase);

    final models = [MockClass(), MockClass()];
    final response = await service.updateBatch(models);
    expect(response.models.isNotEmpty, equals(true));
  });

  test('ModelUpdateJsonObject', () async {
    testDatabase.httpClient = testMockClient(body: '[{"id":1}]');
    final service = MockClassModel(database: testDatabase);
    final partialModel = {"id": 1};
    final response = await service.updatePartial(partialModel);
    expect(response.models.isNotEmpty, equals(true));
  });

  test('ModelDeleteModel', () async {
    testDatabase.httpClient =
        testMockClient(body: '', headers: {'Content-Range': '*/1'});
    final service = MockClassModel(database: testDatabase);

    final model = MockClass(id: 1);
    final response = await service.delete(model);
    expect(response.count, equals(1));
  });

  test('ModelDeleteBatch', () async {
    testDatabase.httpClient =
        testMockClient(body: '', headers: {'Content-Range': '*/2'});
    final service = MockClassModel(database: testDatabase);

    final response = await service.deleteBatch(Query("?id=in.[1,2,3]"));
    expect(response.count, equals(2));
  });
}
