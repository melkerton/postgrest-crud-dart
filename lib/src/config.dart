class PostgrestConfig {
  String url;
  String schema;
  String? bearerToken;
  PostgrestConfig({required this.url, required this.schema, this.bearerToken});
}
