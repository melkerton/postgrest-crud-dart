class PostgrestConfig {
  final String url;
  final String schema;
  String? bearerToken;
  PostgrestConfig({required this.url, required this.schema, this.bearerToken});
}
