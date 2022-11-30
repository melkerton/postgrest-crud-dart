typedef JsonObject = Map<String, dynamic>;

typedef PostgrestPrefer = Map<String, String>;

extension DatabasePreferToString on PostgrestPrefer {
  String render() {
    return entries.map((p) => "${p.key}=${p.value}").toList().join('&');
  }
}
