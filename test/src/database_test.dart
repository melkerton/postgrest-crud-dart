@Tags(['database'])
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:postgrest_crud/postgrest_crud.dart';
import '../setup.dart';

void main() {
  setUp(runSetup);

  test('DatabaseAuth', () async {
    testDatabase.httpClient = testMockClient(preResponse: (Request request) {
      expect(request.headers.containsKey('Authorization'), true);
      expect(request.headers['Authorization'], equals('Bearer TOKEN'));
    });

    await testDatabase.sendRequest(method: HttpMethod.get, modelName: "todo");
  });

  test('DatabaseDelete', () async {
    testDatabase.httpClient = testMockClient(preResponse: (Request request) {
      expect(request.method, equals(HttpMethod.delete.value));
      expect(request.url, equals(Uri.parse("http://localhost/todo?id=eq.1")));

      expect(request.headers.containsKey('Content-Profile'), true);
      expect(request.headers['Content-Profile'], equals('test'));
    });

    await testDatabase.delete(modelName: "todo", query: Query("?id=eq.1"));
  });

  test('DatabaseGet', () async {
    testDatabase.httpClient = testMockClient(preResponse: (Request request) {
      expect(request.method, equals(HttpMethod.get.value));
      expect(request.url, equals(Uri.parse("http://localhost/todo?id=eq.1")));

      expect(request.headers.containsKey('Accept-Profile'), true);
      expect(request.headers['Accept-Profile'], equals('test'));
    });

    await testDatabase.get(modelName: "todo", query: Query("?id=eq.1"));
  });

  test('DatabaseHead', () async {
    testDatabase.httpClient = testMockClient(preResponse: (Request request) {
      expect(request.method, equals(HttpMethod.head.value));
      expect(request.url, equals(Uri.parse("http://localhost/todo")));

      expect(request.headers.containsKey('Accept-Profile'), true);
      expect(request.headers['Accept-Profile'], equals('test'));
    });

    await testDatabase.head(modelName: "todo");
  });

  test('DatabasePatch', () async {
    testDatabase.httpClient = testMockClient(preResponse: (Request request) {
      expect(request.method, equals(HttpMethod.patch.value));
      expect(request.url, equals(Uri.parse("http://localhost/todo")));

      expect(request.headers.containsKey('Content-Profile'), true);
      expect(request.headers['Content-Profile'], equals('test'));

      expect(request.body, equals('{"id": 1}'));
    });

    await testDatabase.patch(modelName: "todo", body: '{"id": 1}');
  });

  test('DatabasePost', () async {
    testDatabase.httpClient = testMockClient(preResponse: (Request request) {
      expect(request.method, equals(HttpMethod.post.value));
      expect(request.url, equals(Uri.parse("http://localhost/todo")));

      expect(request.headers.containsKey('Content-Profile'), true);
      expect(request.headers['Content-Profile'], equals('test'));

      expect(request.body, equals('{"id": 1}'));
    });

    await testDatabase.post(modelName: "todo", body: '{"id": 1}');
  });

  test('DatabasePut', () async {
    testDatabase.httpClient = testMockClient(preResponse: (Request request) {
      expect(request.method, equals(HttpMethod.put.value));
      expect(request.url, equals(Uri.parse("http://localhost/todo")));

      expect(request.headers.containsKey('Content-Profile'), true);
      expect(request.headers['Content-Profile'], equals('test'));

      expect(request.body, equals('{"id": 1}'));
    });

    await testDatabase.put(modelName: "todo", body: '{"id": 1}');
  });
}
