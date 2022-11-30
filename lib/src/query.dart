class Query {
  final String? queryString;

  Query(this.queryString);

  @override
  String toString() {
    if (queryString != null) return queryString!;
    return "";
  }
}
