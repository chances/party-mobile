typedef Future<CacheEntry<T>> CacheDefer<T>();

class Cache {
  Map<String, CacheEntry<dynamic>> _store = Map();

  static Cache _instance = Cache();

  static void set(String key, CacheEntry<dynamic> value) {
    _instance._store[key] = value;
  }

  static Future<T> get<T>(String key, {CacheDefer<T> defer}) async {
    if (_instance._store.containsKey(key)) {
      CacheEntry<T> entry = _instance._store[key];
      if (!entry.isExpired) return entry.value;

      _instance._store.remove(key);
    }

    if (defer != null) {
      var entry = await defer();
      Cache.set(key, entry);
      return entry.value;
    }

    return null;
  }
}

class CacheEntry<T> {
  int expiry;
  T value;

  CacheEntry(this.value, [Duration expiresAfter]) {
    expiry = expiresAfter == null
        ? 0
        : _nowUtc.add(expiresAfter).millisecondsSinceEpoch;
  }

  CacheEntry.expiresAfter(this.value, {int minutes = 0, int hours = 0}) {
    expiry = minutes <= 0 && hours <= 0
        ? 0
        : _nowUtc
            .add(Duration(minutes: minutes, hours: hours))
            .millisecondsSinceEpoch;
  }

  bool get isExpired => expiry == 0
      ? false
      : DateTime.fromMillisecondsSinceEpoch(expiry, isUtc: true)
          .isBefore(_nowUtc);

  DateTime get _nowUtc => DateTime.now().toUtc();
}
