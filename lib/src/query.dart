import 'package:postgrest_crud/postgrest_crud.dart';

/// Creates a `Query` that generates a URL query string.
class Query {
  // Sets limit for query.
  int _limit = 0;

  /// Sets offset for query.
  int offset = 0;

  // List of `Filter`s used for this.
  final List<Filter> _filters = [];

  // List of orderings for this.
  final Map<String, OrderEnum> _order = {};

  // Directly set query.
  String? _queryString;

  // List of select values.
  final List<String> _select = [];

  /// Set the limit for this, and
  /// allow for setting the query string directly (with or without leading '?').
  Query({int? limit, String? query}) {
    if (query != null) {
      if (query.startsWith("?") == false) {
        query = "?$query";
      }
      _queryString = query;
    }

    if (limit != null) {
      _limit = limit;
    }
  }

  /// Append a `Filter` to this.
  void filter(Filter filter) => _filters.add(filter);

  /// Add an ordering on column with direction.
  void order(String column, {OrderEnum direction = OrderEnum.asc}) =>
      _order[column] = direction;

  /// Add a select value to query.
  void select(String select) => _select.add(select.toUrlEncoded());

  /// Render this to a valid query string
  @override
  String toString() {
    if (_queryString != null) return _queryString!;

    // param map for final query
    Map<String, String> params = {};

    // add select
    if (_select.isNotEmpty) {
      params['select'] = _select.join(',');
    }

    // add filters
    for (final filter in _filters) {
      params[filter.column] = filter.toString();
    }

    // add ordering
    if (_order.isNotEmpty) {
      params['order'] = _order.entries
          .map((o) => '${o.key}.${o.value.name}')
          .toList()
          .join(",");
    }

    // add offset
    if (offset > 0) params['offset'] = "$offset";

    // add limit
    if (_limit > 0) params['limit'] = "$_limit";
    final q =
        params.entries.map((p) => "${p.key}=${p.value}").toList().join('&');
    return "?$q";
  }
}

/// Ordering direction options.
enum OrderEnum { asc, desc }
