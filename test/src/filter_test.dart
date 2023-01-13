@Tags(['filter'])
import 'package:test/test.dart';
import 'package:postgrest_crud/postgrest_crud.dart';

class Alpha {}

main() {
  test('FilterBase', () {
    expect(Filter.isEq("a", "b").toString(), equals("eq.b"));
    expect(Filter.isEq("a", "b").toString(nested: true), equals("a.eq.b"));

    expect(Filter.isEq("a", "b").toString(), equals("eq.b"));
    expect(Filter.isEq("a", "b").toString(nested: true), equals("a.eq.b"));
    //print(Filter.isEq("id", Alpha()).toString());
  });

  test('FilterCheckOperators', () {
    expect(Filter.isEq("a", "b").toString(), equals("eq.b"));
    expect(Filter.isGt("a", "b").toString(), equals("gt.b"));
    expect(Filter.isGte("a", "b").toString(), equals("gte.b"));
    expect(Filter.isLt("a", "b").toString(), equals("lt.b"));
    expect(Filter.isLte("a", "b").toString(), equals("lte.b"));
    expect(Filter.isNeq("a", "b").toString(), equals("neq.b"));
    expect(Filter.isLike("a", "%b").toString(), equals("like.*b"));
    expect(Filter.isILike("a", "b%").toString(), equals("ilike.b*"));
    expect(Filter.isMatch("a", "b").toString(), equals("match.b"));
    expect(Filter.isIMatch("a", "b").toString(), equals("imatch.b"));
    expect(Filter.isIn("a", "(b)").toString(), equals("in.(b)"));
    expect(Filter.isIn("a", ['b', 'c']).toString(), equals("in.(b%2Cc)"));
    expect(Filter.isIs("a", "b").toString(), equals("is.b"));
    expect(Filter.isFts("a", "b").toString(), equals("fts.b"));
    expect(Filter.isPlfts("a", "b").toString(), equals("plfts.b"));
    expect(Filter.isPhfts("a", "b").toString(), equals("phfts.b"));
    expect(Filter.isWfts("a", "b").toString(), equals("wfts.b"));
    expect(Filter.isCs("a", "b").toString(), equals("cs.b"));
    expect(Filter.isCs("a", ['b', 'c']).toString(), equals("cs.%7Bb%2Cc%7D"));
    expect(Filter.isCd("a", "b").toString(), equals("cd.b"));
    expect(Filter.isCd("a", ['b', 'c']).toString(), equals("cd.%7Bb%2Cc%7D"));
    expect(Filter.isOv("a", "b").toString(), equals("ov.b"));
    expect(Filter.isOv("a", ['b', 'c']).toString(), equals("ov.%5Bb%2Cc%5D"));
    expect(Filter.isSl("a", "b").toString(), equals("sl.b"));
    expect(Filter.isSl("a", ['b', 'c']).toString(), equals("sl.(b%2Cc)"));
    expect(Filter.isSr("a", "b").toString(), equals("sr.b"));
    expect(Filter.isNxr("a", "b").toString(), equals("nxr.b"));
    expect(Filter.isNxr("a", ['b', 'c']).toString(), equals("nxr.(b%2Cc)"));
    expect(Filter.isNxl("a", "b").toString(), equals("nxl.b"));
    expect(Filter.isNxl("a", ['b', 'c']).toString(), equals("nxl.(b%2Cc)"));
    expect(Filter.isAdj("a", "b").toString(), equals("adj.b"));
    expect(Filter.isAdj("a", ['b', 'c']).toString(), equals("adj.(b%2Cc)"));
  });

  test('FilterCheckNegatedOperators', () {
    expect(Filter.isEq("a", "b", negated: true).toString(), equals("not.eq.b"));
    expect(Filter.isGt("a", "b", negated: true).toString(), equals("not.gt.b"));

    expect(
        Filter.isGte("a", "b", negated: true).toString(), equals("not.gte.b"));

    expect(Filter.isLt("a", "b", negated: true).toString(), equals("not.lt.b"));

    expect(
        Filter.isLte("a", "b", negated: true).toString(), equals("not.lte.b"));

    expect(
        Filter.isNeq("a", "b", negated: true).toString(), equals("not.neq.b"));

    expect(Filter.isLike("a", "%b", negated: true).toString(),
        equals("not.like.*b"));

    expect(Filter.isILike("a", "b%", negated: true).toString(),
        equals("not.ilike.b*"));

    expect(Filter.isMatch("a", "b", negated: true).toString(),
        equals("not.match.b"));

    expect(Filter.isIn("a", "b", negated: true).toString(), equals("not.in.b"));
    expect(Filter.isIs("a", "b", negated: true).toString(), equals("not.is.b"));

    expect(Filter.isIMatch("a", "b", negated: true).toString(),
        equals("not.imatch.b"));

    expect(
        Filter.isFts("a", "b", negated: true).toString(), equals("not.fts.b"));

    expect(Filter.isPlfts("a", "b", negated: true).toString(),
        equals("not.plfts.b"));

    expect(Filter.isPhfts("a", "b", negated: true).toString(),
        equals("not.phfts.b"));

    expect(Filter.isWfts("a", "b", negated: true).toString(),
        equals("not.wfts.b"));

    expect(Filter.isCs("a", "b", negated: true).toString(), equals("not.cs.b"));
    expect(Filter.isCd("a", "b", negated: true).toString(), equals("not.cd.b"));
    expect(Filter.isOv("a", "b", negated: true).toString(), equals("not.ov.b"));
    expect(Filter.isSl("a", "b", negated: true).toString(), equals("not.sl.b"));
    expect(Filter.isSr("a", "b", negated: true).toString(), equals("not.sr.b"));

    expect(
        Filter.isNxl("a", "b", negated: true).toString(), equals("not.nxl.b"));

    expect(
        Filter.isNxr("a", "b", negated: true).toString(), equals("not.nxr.b"));

    expect(
        Filter.isAdj("a", "b", negated: true).toString(), equals("not.adj.b"));
  });
}
