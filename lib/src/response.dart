import 'package:http/http.dart' as http;

class Response<T> {
  final List<T> models;
  http.StreamedResponse response;
  int _limit = 0;
  int _count = 0;
  int _offset = 0;

  Response({required this.response, required this.models}) {
    if (response.headers.containsKey('Content-Range')) {
      final matches = RegExp(r'([0-9]+)')
          .allMatches(response.headers['Content-Range']!)
          .toList();

      // Content-Range=[OFFSET]-[OFFSET + LIMIT - 1]/[COUNT]
      // e.g. 9-17/18 => limit = 9, records = (9...17), total search results = 18
      // results = [] => Content-Range=*/0
      if (matches.length == 3) {
        _offset = int.parse(matches[0][0]!);
        _limit = int.parse(matches[1][0]!) - _offset + 1;
        _count = int.parse(matches[2][0]!);
      }
    }
  }

  int get limit => _limit;
  int get count => _count;
  int get offset => _offset;
}
