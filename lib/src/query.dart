class Query {
  String? queryString;

  Query(this.queryString);

  String render() {
    if (queryString != null) return queryString!;
    return "";
  }
}
