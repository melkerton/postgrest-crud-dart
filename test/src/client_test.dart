@Tags(['client'])
import 'package:test/test.dart';
import 'package:postgrest_crud/postgrest_crud.dart';

import '../setup.dart';
import '../mock.dart';

void main() {
  setUp(runSetup);
  test('ClientCreate', () async {
    final testConnection =
        makeTestConnection(testMockClient(body: '[{"id":1}]'));
    final service = MockClassClient(connection: testConnection);
    final model = MockClass();
    final response = await service.create(model);
    expect(response.models.isNotEmpty, equals(true));
    expect(response.models.first.id, equals(1));
  });

  test('ClientCreateBatch', () async {
    final testConnection =
        makeTestConnection(testMockClient(body: '[{"id":1}, {"id":2}]'));
    final service = MockClassClient(connection: testConnection);
    final models = [MockClass(), MockClass()];
    final response = await service.createBatch(models);
    expect(response.models.isNotEmpty, equals(true));
    expect(response.models.length, equals(2));
    expect(response.models.first.id, equals(1));
    expect(response.models[1].id, equals(2));
  });

  test('ClientRecall', () async {
    final mockClient = testMockClient(
        body: '[{"id":1}, {"id":2}]', headers: {"Content-Range": "0-1/20"});
    final testConnection = makeTestConnection(mockClient);
    final service = MockClassClient(connection: testConnection);
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

  test('ClientUpdateClient', () async {
    final testConnection =
        makeTestConnection(testMockClient(body: '[{"id":1}]'));
    final service = MockClassClient(connection: testConnection);
    final model = MockClass(id: 1);
    final response = await service.update(model);
    expect(response.models.isNotEmpty, equals(true));
  });

  test('ClientUpdateClientList', () async {
    final testConnection =
        makeTestConnection(testMockClient(body: '[{"id":1}, {"id":2}]'));
    final service = MockClassClient(connection: testConnection);

    final models = [MockClass(), MockClass()];
    final response = await service.updateBatch(models);
    expect(response.models.isNotEmpty, equals(true));
  });

  test('ClientUpdateJsonObject', () async {
    final testConnection =
        makeTestConnection(testMockClient(body: '[{"id":1}]'));
    final service = MockClassClient(connection: testConnection);
    final partialClient = {"id": 1};
    final response = await service.updatePartial(partialClient);
    expect(response.models.isNotEmpty, equals(true));
  });

  test('ClientDeleteClient', () async {
    final mockClient =
        testMockClient(body: '', headers: {'Content-Range': '*/1'});
    final testConnection = makeTestConnection(mockClient);

    final service = MockClassClient(connection: testConnection);

    final model = MockClass(id: 1);
    final response = await service.delete(model);
    expect(response.count, equals(1));
  });

  test('ClientDeleteBatch', () async {
    final mockClient =
        testMockClient(body: '', headers: {'Content-Range': '*/2'});
    final testConnection = makeTestConnection(mockClient);

    final service = MockClassClient(connection: testConnection);

    final response = await service.deleteBatch(Query("?id=in.[1,2,3]"));
    expect(response.count, equals(2));
  });
}
