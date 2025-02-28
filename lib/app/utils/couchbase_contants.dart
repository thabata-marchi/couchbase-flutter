class CouchbaseContants {
  static const String userName = String.fromEnvironment('COUCHBASE_USERNAME');
  static const String password = String.fromEnvironment('COUCHBASE_PASSWORD');
  static const String channel = String.fromEnvironment('COUCHBASE_CHANNEL');
  static const String collection =
      String.fromEnvironment('COUCHBASE_COLLECTION');
  static const String publicConnectionUrl =
      String.fromEnvironment('COUCHBASE_PUBLIC_CONNECT_URL');
  static const String scope = String.fromEnvironment('COUCHBASE_SCOPE');
}
