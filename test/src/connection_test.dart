@Tags(['connection'])
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:postgrest_crud/postgrest_crud.dart';
import '../setup.dart';

void main() {
  setUp(runSetup);

  test('ConnectionAuth', () async {
    final mockClient = testMockClient(preResponse: (Request request) {
      expect(request.headers.containsKey('Authorization'), true);
      expect(request.headers['Authorization'], equals('Bearer TOKEN'));
    });

    final testConnection = makeTestConnection(mockClient);

    await testConnection.sendRequest(
        method: HttpMethod.get, modelName: "MockClass");
  });

  test('ConnectionDelete', () async {
    final mockClient = testMockClient(preResponse: (Request request) {
      expect(request.method, equals(HttpMethod.delete.name));
      expect(
          request.url, equals(Uri.parse("http://localhost/MockClass?id=eq.1")));

      expect(request.headers.containsKey('Content-Profile'), true);
      expect(request.headers['Content-Profile'], equals('test'));
    });

    final testConnection = makeTestConnection(mockClient);

    await testConnection.delete(
        modelName: "MockClass", query: Query(query: "?id=eq.1"));
  });

  test('ConnectionGet', () async {
    final mockClient = testMockClient(preResponse: (Request request) {
      expect(request.method, equals(HttpMethod.get.name));
      expect(
          request.url, equals(Uri.parse("http://localhost/MockClass?id=eq.1")));

      expect(request.headers.containsKey('Accept-Profile'), true);
      expect(request.headers['Accept-Profile'], equals('test'));
    });

    final testConnection = makeTestConnection(mockClient);
    await testConnection.get(
        modelName: "MockClass", query: Query(query: "?id=eq.1"));
  });

  test('ConnectionHead', () async {
    final mockClient = testMockClient(preResponse: (Request request) {
      expect(request.method, equals(HttpMethod.head.name));
      expect(request.url, equals(Uri.parse("http://localhost/MockClass")));

      expect(request.headers.containsKey('Accept-Profile'), true);
      expect(request.headers['Accept-Profile'], equals('test'));
    });

    final testConnection = makeTestConnection(mockClient);
    await testConnection.head(modelName: "MockClass");
  });

  test('ConnectionPatch', () async {
    final mockClient = testMockClient(preResponse: (Request request) {
      expect(request.method, equals(HttpMethod.patch.name));
      expect(request.url, equals(Uri.parse("http://localhost/MockClass")));

      expect(request.headers.containsKey('Content-Profile'), true);
      expect(request.headers['Content-Profile'], equals('test'));

      expect(request.body, equals('{"id": 1}'));
    });
    final testConnection = makeTestConnection(mockClient);

    await testConnection.patch(modelName: "MockClass", body: '{"id": 1}');
  });

  test('ConnectionPost', () async {
    final mockClient = testMockClient(preResponse: (Request request) {
      expect(request.method, equals(HttpMethod.post.name));
      expect(request.url, equals(Uri.parse("http://localhost/MockClass")));

      expect(request.headers.containsKey('Content-Profile'), true);
      expect(request.headers['Content-Profile'], equals('test'));

      expect(request.body, equals('{"id": 1}'));
    });

    final testConnection = makeTestConnection(mockClient);
    await testConnection.post(modelName: "MockClass", body: '{"id": 1}');
  });

  test('ConnectionPut', () async {
    final mockClient = testMockClient(preResponse: (Request request) {
      expect(request.method, equals(HttpMethod.put.name));
      expect(request.url, equals(Uri.parse("http://localhost/MockClass")));

      expect(request.headers.containsKey('Content-Profile'), true);
      expect(request.headers['Content-Profile'], equals('test'));

      expect(request.body, equals('{"id": 1}'));
    });

    final testConnection = makeTestConnection(mockClient);
    await testConnection.put(modelName: "MockClass", body: '{"id": 1}');
  });

  test('ConnectRpc', () async {
    final mockClient = testMockClient(
        body: '{"alpha":1}',
        preResponse: (Request request) {
          expect(request.method, equals(HttpMethod.post.name));
          expect(
              request.url, equals(Uri.parse("http://localhost/rpc/MockClass")));

          expect(request.body, equals('{"a":1}'));
        });

    final testConnection = makeTestConnection(mockClient);
    final results =
        await testConnection.rpc(function: "MockClass", arguments: {"a": 1});
    expect(results, isA<Map<String, dynamic>>());
    expect(results['alpha'], equals(1));
  });
}
