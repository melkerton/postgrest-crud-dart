@Tags(['query'])
import 'package:test/test.dart';

import 'package:postgrest_crud/postgrest_crud.dart';

main() {
  test('QuerySimple', () {
    final query = Query(limit: 10)
      ..select("*")
      ..order("id", direction: OrderEnum.asc);

    expect(query.toString(), equals("?select=*&order=id.asc&limit=10"));
  });
  test('Query', () {
    final query = Query(limit: 10)
      ..select("*")
      ..filter(Filter.isEq("id", 1))
      ..order("id", direction: OrderEnum.asc);

    expect(query.toString(), equals("?select=*&id=eq.1&order=id.asc&limit=10"));
  });
}
