import 'package:flutter_dotenv/flutter_dotenv.dart';

class CouchbaseContants {
  static String userName = dotenv.get('COUCHBASE_USERNAME');
  static String password = dotenv.get('COUCHBASE_PASSWORD');
  static String channel = dotenv.get('COUCHBASE_CHANNEL');
  static String collection = dotenv.get('COUCHBASE_COLLECTION');
  static String publicConnectionUrl =
      dotenv.get('COUCHBASE_PUBLIC_CONNECT_URL');
  static String scope = dotenv.get('COUCHBASE_SCOPE');
}
