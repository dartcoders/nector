class NectorNetworkResponse {
  int? statusCode = 0;
  int size = 0;
  DateTime time = DateTime.now();
  dynamic body;
  Map<String, String> headers = <String, String>{};
}
