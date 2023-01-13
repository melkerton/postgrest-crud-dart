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
  ///
  /// Setting `negated = true` prefixes operator with `not`.
  Filter(this.column, this.operator, String value, this.negated)
      : value = value.toUrlEncoded();

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
      Filter(column, "eq", dynamicToString(value), negated);

  /// Postgresql: `>`, meaning: greater than.
  static Filter isGt(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "gt", dynamicToString(value), negated);

  /// Postgresql: `>=`, meaning: greater than or equal.
  static Filter isGte(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "gte", dynamicToString(value), negated);

  /// Postgresql: `<`, meaning: less than.
  static Filter isLt(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "lt", dynamicToString(value), negated);

  /// Postgresql: `<=`, meaning: less than or equal.
  static Filter isLte(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "lte", dynamicToString(value), negated);

  /// Postgresql: `<>` or `!=`, meaning: not equal.
  static Filter isNeq(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "neq", dynamicToString(value), negated);

  /// Postgresql: `LIKE`, meaning: LIKE operator.
  ///
  /// Replaces `%` with `*`, (to avoid
  /// [URL encoding](https://en.wikipedia.org/wiki/Percent-encoding)
  /// you can use `*` as an alias of the percent sign `%` for the pattern).
  static Filter isLike(String column, dynamic value, {bool negated = false}) =>
      Filter(
          column, "like", dynamicToString(value).replaceAll('%', '*'), negated);

  /// Postgresql: `ILIKE`, meaning: ILIKE operator.
  ///
  /// Replaces `%` with `*`, (to avoid
  /// [URL encoding](https://en.wikipedia.org/wiki/Percent-encoding)
  /// you can use `*` as an alias of the percent sign `%` for the pattern).
  static Filter isILike(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "ilike", dynamicToString(value).replaceAll('%', '*'),
          negated);

  /// Postgresql: `~`, meaning: ~ operator, see [Pattern Matching](https://postgrest.org/en/stable/api.html#pattern-matching).
  static Filter isMatch(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "match", dynamicToString(value), negated);

  /// Postgresql: `~*`, meaning: ~ operator, see [Pattern Matching](https://postgrest.org/en/stable/api.html#pattern-matching).
  static Filter isIMatch(String column, dynamic value,
          {bool negated = false}) =>
      Filter(column, "imatch", dynamicToString(value), negated);

  /// Postgresql: `IN`, meaning: one of a list of values.
  ///
  /// e.g. ?a=in.(1,2,3) – also supports commas in quoted strings like `?a=in.("hi,there","yes,you")`.
  /// Passing a value as a `List` will generate the correct format.
  static Filter isIn(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "in", dynamicToString(value), negated);

  /// Postgresql: `IS`, meaning: checking for exact equality `(null,true,false,unknown)`.
  static Filter isIs(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "is", dynamicToString(value), negated);

  /// Postgresql: `@@`, meaning: [Full-Text](https://postgrest.org/en/stable/api.html#fts)
  /// Search using to_tsquery.
  static Filter isFts(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "fts", dynamicToString(value), negated);

  /// Postgresql: `@@`, meaning: [Full-Text](https://postgrest.org/en/stable/api.html#fts)
  /// Search using plainto_tsquery.
  static Filter isPlfts(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "plfts", dynamicToString(value), negated);

  /// Postgresql: `@@`, meaning: [Full-Text](https://postgrest.org/en/stable/api.html#fts)
  /// Search using phraseto_tsquery.
  static Filter isPhfts(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "phfts", dynamicToString(value), negated);

  /// Postgresql: `@@`, meaning: [Full-Text](https://postgrest.org/en/stable/api.html#fts)
  /// Search using websearch_to_tsquery.
  static Filter isWfts(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "wfts", dynamicToString(value), negated);

  /// Passing a value as a `List` will generate the correct format.
  ///
  /// Postgresql: `@>`, meaning: contains e.g. `?tags=cs.{example, new}`.
  static Filter isCs(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "cs",
          dynamicToString(value, leftDelim: '{', rightDelim: '}'), negated);

  /// Passing a value as a `List` will generate the correct format.
  ///
  /// Postgresql: `<@`, meaning: contained in e.g. `?values=cd.{1,2,3}`.
  /// Passing a value as a `List` will generate the correct format.
  static Filter isCd(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "cd",
          dynamicToString(value, leftDelim: '{', rightDelim: '}'), negated);

  /// Postgresql: `&&`, meaning: overlap (have points in common).
  ///
  /// e.g. `?period=ov.[2017-01-01,2017-06-30]` – also supports array types,
  /// use curly braces instead of square brackets e.g. :code: `?arr=ov.{1,3}`.
  /// Passing a value as a `List` will generate the correct format.
  static Filter isOv(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "ov",
          dynamicToString(value, leftDelim: '[', rightDelim: ']'), negated);

  /// Postgresql: `<<`, meaning: strictly left of, e.g. `?range=sl.(1,10)`.
  ///
  /// Passing a value as a `List` will generate the correct format.
  static Filter isSl(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "sl", dynamicToString(value), negated);

  /// Postgresql: `>>`, meaning: strictly right of.
  static Filter isSr(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "sr", dynamicToString(value), negated);

  /// Postgresql: `&<`, meaning: does not extend to the right of, e.g. `?range=nxr.(1,10)`.
  ///
  /// Passing a value as a `List` will generate the correct format.
  static Filter isNxr(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "nxr", dynamicToString(value), negated);

  /// Postgresql: `&>`, meaning: does not extend to the left of, e.g. `?range=nxl.(1,10)`.
  ///
  /// Passing a value as a `List` will generate the correct format.
  static Filter isNxl(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "nxl", dynamicToString(value), negated);

  /// Postgresql: `-|-`, meaning: is adjacent to, e.g. `?range=adj.(1,10)`.
  ///
  /// Passing a value as a `List` will generate the correct format.
  static Filter isAdj(String column, dynamic value, {bool negated = false}) =>
      Filter(column, "adj", dynamicToString(value), negated);
}

String dynamicToString(dynamic value, {String? leftDelim, String? rightDelim}) {
  try {
    if (value is List) {
      leftDelim = leftDelim ?? "(";
      rightDelim = rightDelim ?? ")";
      return "$leftDelim${value.map((v) => v.toString()).toList().join(',')}$rightDelim";
    }

    return value.toString();
  } on NoSuchMethodError {
    throw PostgrestCrudException("Filter values must support `toString()`.");
  }
}
