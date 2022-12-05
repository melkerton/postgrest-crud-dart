import 'package:postgrest_crud/postgrest_crud.dart';

/// Creates a parameter filter (Horizontal Filtering).
///
/// See https://postgrest.org/en/stable/api.html (Tables and Views)
/// for full list of operators.
/// All static constructors are prefixed with `is` to avoid keyword conflicts.
class Filter {
  /// The column to operate on.
  final String column;

  /// The operator to use for comparison.
  final String operator;

  /// The final url encoded value.
  final String value;

  /// Negates this operator, see
  /// [Logical operators](https://postgrest.org/en/stable/api.html#logical-operators).
  final bool negated;

  /// Creates a `Filter` for use with `Query`. Prefer using static methods.
  Filter(this.column, this.operator, this.value, this.negated);

  /// Returns a context based string (rhs) of query.
  ///
  /// nested ? column.(not.)operator.value : (not.)operator.value
  @override
  String toString({bool nested = false}) {
    var rhs = "$operator.$value";

    if (negated) {
      rhs = "not.$rhs";
    }

    if (nested) {
      return "$column.$rhs";
    }

    return rhs;
  }

  /// Postgresql: `=`, meaning: equals.
  static Filter isEq(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "eq", "$value".toUrlEncoded(), negated);

  /// Postgresql: `>`, meaning: greater than.
  static Filter isGt(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "gt", "$value".toUrlEncoded(), negated);

  /// Postgresql: `>=`, meaning: greater than or equal.
  static Filter isGte(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "gte", "$value".toUrlEncoded(), negated);

  /// Postgresql: `<`, meaning: less than.
  static Filter isLt(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "lt", "$value".toUrlEncoded(), negated);

  /// Postgresql: `<=`, meaning: less than or equal.
  static Filter isLte(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "lte", "$value".toUrlEncoded(), negated);

  /// Postgresql: `<>` or `!=`, meaning: not equal.
  static Filter isNeq(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "neq", "$value".toUrlEncoded(), negated);

  /// Postgresql: `LIKE`, meaning: LIKE operator.
  ///
  /// Replaces `%` with `*`, (to avoid
  /// [URL encoding](https://en.wikipedia.org/wiki/Percent-encoding)
  /// you can use `*` as an alias of the percent sign `%` for the pattern).
  static Filter isLike(String column, dynamic value, {bool negated = false}) {
    value = "$value".replaceAll('%', '*');
    return Filter(column, "like", "$value".toUrlEncoded(), negated);
  }

  /// Postgresql: `ILIKE`, meaning: ILIKE operator.
  ///
  /// Replaces `%` with `*`, (to avoid
  /// [URL encoding](https://en.wikipedia.org/wiki/Percent-encoding)
  /// you can use `*` as an alias of the percent sign `%` for the pattern).
  static Filter isILike(String column, dynamic value, {bool negated = false}) {
    value = "$value".replaceAll('%', '*');
    return Filter(column, "ilike", "$value".toUrlEncoded(), negated);
  }

  /// Postgresql: `~`, meaning: ~ operator, see [Pattern Matching](https://postgrest.org/en/stable/api.html#pattern-matching).
  static Filter isMatch(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "match", "$value".toUrlEncoded(), negated);

  /// Postgresql: `~*`, meaning: ~ operator, see [Pattern Matching](https://postgrest.org/en/stable/api.html#pattern-matching).
  static Filter isIMatch(String column, dynamic value,
          {bool negated = false}) =>
      Filter(column, "imatch", "$value".toUrlEncoded(), negated);

  /// Postgresql: `IN`, meaning: one of a list of values.
  ///
  /// e.g. ?a=in.(1,2,3) – also supports commas in quoted strings like `?a=in.("hi,there","yes,you")`.
  static Filter isIn(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "in", "$value".toUrlEncoded(), negated);

  /// Postgresql: `IS`, meaning: checking for exact equality `(null,true,false,unknown)`.
  static Filter isIs(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "is", "$value".toUrlEncoded(), negated);

  /// Postgresql: `@@`, meaning: [Full-Text](https://postgrest.org/en/stable/api.html#fts)
  /// Search using to_tsquery.
  static Filter isFts(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "fts", "$value".toUrlEncoded(), negated);

  /// Postgresql: `@@`, meaning: [Full-Text](https://postgrest.org/en/stable/api.html#fts)
  /// Search using plainto_tsquery.
  static Filter isPlfts(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "plfts", "$value".toUrlEncoded(), negated);

  /// Postgresql: `@@`, meaning: [Full-Text](https://postgrest.org/en/stable/api.html#fts)
  /// Search using phraseto_tsquery.
  static Filter isPhfts(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "phfts", "$value".toUrlEncoded(), negated);

  /// Postgresql: `@@`, meaning: [Full-Text](https://postgrest.org/en/stable/api.html#fts)
  /// Search using websearch_to_tsquery.
  static Filter isWfts(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "wfts", "$value".toUrlEncoded(), negated);

  /// Postgresql: `@>`, meaning: contains e.g. `?tags=cs.{example, new}`.
  static Filter isCs(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "cs", "$value".toUrlEncoded(), negated);

  /// Postgresql: `<@`, meaning: contained in e.g. `?values=cd.{1,2,3}`.
  static Filter isCd(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "cd", "$value".toUrlEncoded(), negated);

  /// Postgresql: `&&`, meaning: overlap (have points in common).
  ///
  /// e.g. `?period=ov.[2017-01-01,2017-06-30]` – also supports array types,
  /// use curly braces instead of square brackets e.g. :code: `?arr=ov.{1,3}`.
  static Filter isOv(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "ov", "$value".toUrlEncoded(), negated);

  /// Postgresql: `<<`, meaning: strictly left of, e.g. `?range=sl.(1,10)`.
  static Filter isSl(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "sl", "$value".toUrlEncoded(), negated);

  /// Postgresql: `>>`, meaning: strictly right of.
  static Filter isSr(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "sr", "$value".toUrlEncoded(), negated);

  /// Postgresql: `&<`, meaning: does not extend to the right of, e.g. `?range=nxr.(1,10)`.
  static Filter isNxr(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "nxr", "$value".toUrlEncoded(), negated);

  /// Postgresql: `&>`, meaning: does not extend to the left of.
  static Filter isNxl(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "nxl", "$value".toUrlEncoded(), negated);

  /// Postgresql: `-|-`, meaning: is adjacent to, e.g. `?range=adj.(1,10)`.
  static Filter isAdj(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "adj", "$value".toUrlEncoded(), negated);
}
