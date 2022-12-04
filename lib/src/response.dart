import 'package:http/http.dart' as http;
import 'package:postgrest_crud/postgrest_crud.dart';

/// Provides models and offset, limit, count from 'Content-Range' response header.
class Response<T> {
  final List<JsonObject> jsonObjects;

  /// List of models from response.
  final List<T> models;

  /// Response from [http.Client] request.
  final http.StreamedResponse response;

  int _limit = 0;
  int _count = 0;
  int _offset = 0;

  /// Create a response object with models and paging related information.
  Response(
      {required this.response,
      required this.jsonObjects,
      required this.models}) {
    String? contentRange;
    if (response.headers.containsKey('Content-Range')) {
      contentRange = response.headers['Content-Range']!;
    }

    if (response.headers.containsKey('content-range')) {
      contentRange = response.headers['content-range']!;
    }

    if (contentRange != null) {
      final matches = RegExp(r'([0-9]+)').allMatches(contentRange).toList();

      // Content-Range=[OFFSET]-[OFFSET + LIMIT - 1]/[COUNT]
      // e.g. 9-17/18 => limit = 9, records = (9...17), total search results = 18
      // results = [] => Content-Range=0-1/2
      if (matches.length == 3) {
        _offset = int.parse(matches[0][0]!);
        _limit = int.parse(matches[1][0]!) - _offset + 1;
        _count = int.parse(matches[2][0]!);
      } else if (matches.isNotEmpty) {
        // results = [] => Content-Range=*/0
        _count = int.parse(matches.last[0]!);
      }
    }
  }

  /// Estimated limit derived from `Content-Range` headers.
  ///
  /// May not reflect limit set in request parameters. Limit is calculated as
  /// the difference between the first record index and the last record index.
  int get limit => _limit;

  /// Count of the total records from a given [Query].
  ///
  /// Default Prefer is count=exact.
  int get count => _count;

  /// The index of the first record.
  int get offset => _offset;
}
