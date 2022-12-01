/// Provides access to set set the Prefer header for Postgrest.
class PostgrestPrefer {
  final String? _count;
  final String? _resolution;
  final String? _return;
  final String? _tx;
  PostgrestPrefer(
      {String? countValue,
      String? resolutionValue,
      String? returnValue,
      String? txValue})
      : _count = countValue,
        _resolution = resolutionValue,
        _return = returnValue,
        _tx = txValue;

  @override
  String toString() {
    List<String> prefer = [];
    if (_count != null) prefer.add("count=$_count");
    if (_resolution != null) prefer.add("resolution=$_resolution");
    if (_return != null) prefer.add("return=$_return");
    if (_tx != null) prefer.add("tx=$_tx");
    return prefer.join(',');
  }
}

/*
// rpc
params:
  single-object
  multiple-objects

// table
resolution:
  merge-duplicates
  ignore-duplicates

return:
  representation
  headers-only

tx?:
  commit
  commit-allow-override
  rollback
  rollback-allow-override

*/