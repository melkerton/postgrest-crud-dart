/// A Future based interface to Postgrest.
library postgrest_crud;

export 'src/client.dart';
export 'src/config.dart';
export 'src/connection.dart';
export 'src/exception.dart';
export 'src/filter.dart';
export 'src/http.dart';
export 'src/prefer.dart';
export 'src/query.dart';
export 'src/response.dart';
export 'src/typedef.dart';

/// Encode url values.
extension UrlEncodingExtension on String {
  String toUrlEncoded() {
    return Uri.encodeComponent(this);
  }
}
