/// The main configuration to connect to Postgrest server.
///
/// url and schema are required, optionally set bearerToken for Authorization.
class PostgrestConfig {
  /// Full url of Postgrest server. e.g. http://localhost
  final String url;

  /// Schema to use in requests. Sets `(Content|Accept)-Profile` header.
  final String schema;

  /// Optional authorization. Sets `Authorization: Bearer BEARER-TOKEN` header.
  String? bearerToken;

  /// Create a PostgrestConfig with required parameters.
  PostgrestConfig({required this.url, required this.schema, this.bearerToken});
}
