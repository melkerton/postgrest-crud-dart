/// The main configuration to connect to Postgrest server.
///
/// url and schema are required, optionally set bearerToken for Authorization.
class PostgrestConfig {
  final String url;
  final String schema;
  String? bearerToken;
  PostgrestConfig({required this.url, required this.schema, this.bearerToken});
}
