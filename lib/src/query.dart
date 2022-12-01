class Query {
  String? _queryString;

  /// Allow for setting the query string directly (with or without leading '?').
  Query(String? queryString) {
    if (queryString != null) {
      if (queryString.startsWith("?") == false) {
        queryString = "?$queryString";
      }
      _queryString = queryString;
    }
  }

  @override
  String toString() {
    if (_queryString != null) return _queryString!;
    return "";
  }
}
